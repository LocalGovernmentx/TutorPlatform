import logging
import boto3
from botocore.exceptions import ClientError
import os
from dotenv import load_dotenv

logger = logging.getLogger(__name__)
load_dotenv(verbose=True)

class SnsWrapper:
    """Encapsulates Amazon SNS topic and subscription functions."""

    def __init__(self, sns_resource):
        """
        :param sns_resource: A Boto3 Amazon SNS resource.
        """
        self.sns_resource = sns_resource

    def select_topic(self):
        """
        선택할 topic을 list중에서 골라내 반환.
        :return: selected topics.
        """
        try:
            topics_iter = self.sns_resource.topics.all()
            for i, topic in enumerate(topics_iter):
                if "PythonServiceTestTopic" in topic.arn:
                    logger.info("Got topics.")
                    print(topic)
                    return topic

        except ClientError:
            logger.exception("Couldn't get topics.")
            raise

    @staticmethod
    def publish_message(topic, message, attributes):
        try:
            att_dict = {}
            for key, value in attributes.items():
                if isinstance(value, str):
                    att_dict[key] = {"DataType": "String", "StringValue": value}
                elif isinstance(value, bytes):
                    att_dict[key] = {"DataType": "Binary", "BinaryValue": value}
            response = topic.publish(Message=message, MessageAttributes=att_dict)
            message_id = response["MessageId"]
            logger.info(
                "Published message with attributes %s to topic %s.",
                attributes,
                topic.arn,
            )
        except ClientError:
            logger.exception("Couldn't publish message to topic %s.", topic.arn)
            raise
        else:
            return message_id


def usage_demo():
    logging.basicConfig(level=logging.INFO, format="%(levelname)s: %(message)s")
    key = "mobile"
    value = "friendly"
    resource = boto3.resource(
        "sns",
        aws_access_key_id=os.getenv('AWS_ACCESS_KEY_ID'),
        aws_secret_access_key=os.getenv('AWS_SECRET_ACCESS_KEY'),
        region_name=os.getenv('REGION_NAME'),
    )
    sns_wrapper = SnsWrapper(resource)
    topic = sns_wrapper.select_topic()
    sns_wrapper.publish_message(topic, "test message", {key: value})


if __name__ == "__main__":
    usage_demo()
