package com.sm.tutor.service;

import jakarta.annotation.PostConstruct;
import java.io.InputStream;
import java.net.URL;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;
import software.amazon.awssdk.services.s3.model.PutObjectResponse;

@Service
public class S3Service {

  private S3Client s3Client;

  @Value("${cloud.aws.credentials.access-key}")
  private String accessKey;

  @Value("${cloud.aws.credentials.secret-key}")
  private String secretKey;

  @Value("${cloud.aws.region.static}")
  private String region;

  @Value("${cloud.aws.s3.bucket}")
  private String bucket;

  @PostConstruct
  public void initialize() {
    s3Client = S3Client.builder()
        .region(Region.of(region))
        .credentialsProvider(
            StaticCredentialsProvider.create(AwsBasicCredentials.create(accessKey, secretKey)))
        .build();
  }

  /**
   * Uploads a file to an S3 bucket.
   *
   * @param fileName      The name of the file to be uploaded.
   * @param inputStream   The input stream of the file.
   * @param contentLength The length of the file content.
   * @return The URL of the uploaded file.
   */
  public String uploadFile(String fileName, InputStream inputStream, long contentLength) {
    try {
      // Define the folder structure
      String folderName = "main-images"; // specify the folder name
      String key = folderName + "/" + fileName;

      PutObjectRequest putObjectRequest = PutObjectRequest.builder()
          .bucket(bucket)
          .key(key)
          .build();

      PutObjectResponse response = s3Client.putObject(putObjectRequest,
          RequestBody.fromInputStream(inputStream, contentLength));

      // Generate the URL of the uploaded file
      URL fileUrl = s3Client.utilities().getUrl(b -> b.bucket(bucket).key(key));

      return fileUrl.toString();
    } catch (Exception e) {
      e.printStackTrace();
      return null;
    }
  }
}
