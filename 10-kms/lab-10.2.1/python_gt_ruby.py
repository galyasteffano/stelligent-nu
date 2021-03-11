import boto3
import os
import sys
import base64

KEY_ID = 'alias/ASnazzyName'

def give_help_goodbye():
    print(
        """
        Usage: python python_gt_ruby.py <encrypt|decrypt> <file_path_input>
        output is printed to std.out
        """)
    sys.exit(1)

def main():
    if sys.argv.__len__() != 3:
        give_help_goodbye()
    kms = boto3.client('kms')
    if sys.argv[1] == 'encrypt':
        if os.path.exists(sys.argv[2]):
            encrypt_me = open(sys.argv[2]).read()
            print(
                str(
                    base64.b64encode(
                        kms.encrypt(
                            KeyId=KEY_ID,
                            Plaintext=encrypt_me
                        )['CiphertextBlob']
                    ),
                    "utf-8"
                )
            )
        else:
            give_help_goodbye()
    elif sys.argv[1] == 'decrypt':
        if os.path.exists(sys.argv[2]):
            decrypt_me = open(sys.argv[2]).read()
            print(
                str(
                    kms.decrypt(
                        KeyId=KEY_ID,
                        CiphertextBlob=bytes(base64.b64decode(decrypt_me))
                    )['Plaintext'],
                    "utf-8"
                )
            )
        else:
            give_help_goodbye()
    else:
        give_help_goodbye()

if __name__ == "__main__":
    main()