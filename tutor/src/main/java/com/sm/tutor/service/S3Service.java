package com.sm.tutor.service;

import jakarta.annotation.PostConstruct;
import java.io.InputStream;
import java.net.URL;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;

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

  public String uploadFile(String keyName, InputStream inputStream, long contentLength) {
    PutObjectRequest putObjectRequest = PutObjectRequest.builder()
        .bucket(bucket)
        .key(keyName)
        .build();

    s3Client.putObject(putObjectRequest,
        software.amazon.awssdk.core.sync.RequestBody.fromInputStream(inputStream, contentLength));

    // Generate the file URL
    URL url = s3Client.utilities().getUrl(builder -> builder.bucket(bucket).key(keyName));
    return url.toString();
  }
}
