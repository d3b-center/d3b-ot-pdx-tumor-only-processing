import boto3
from botocore.exceptions import ClientError
import argparse
import pdb

parser = argparse.ArgumentParser(
        description = 'get signed urls for downloading')

parser.add_argument('--profile', 
        help='AWS profile name')
parser.add_argument('--bucket',
        help='aws bucket name')
parser.add_argument('--list',
        help='File with list of objects to generate urls for')

args = parser.parse_args()


session = boto3.Session(profile_name=args.profile)
s3_client = session.client('s3')

# Generate a presigned URL for the S3 object
# s3_client = boto3.client('s3')
expiration=3600
for object in open(args.list):
    object = object.rstrip('\n')
    try:
        response = s3_client.generate_presigned_url(ClientMethod='get_object',
                                                    Params={'Bucket': args.bucket,
                                                            'Key': object},
                                                    ExpiresIn=expiration)
        print(response)

    except ClientError as e:
        logging.error(e)
        exit(1)
