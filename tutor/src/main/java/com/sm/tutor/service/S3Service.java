package com.sm.tutor.service;

import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;
import software.amazon.awssdk.services.s3.model.PutObjectResponse;

import java.nio.file.Path;
import java.nio.file.Paths;

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
    public void init() {
        try {
            AwsBasicCredentials awsCreds = AwsBasicCredentials.create(accessKey, secretKey);
            this.s3Client = S3Client.builder()
                    .region(Region.of(region))
                    .credentialsProvider(StaticCredentialsProvider.create(awsCreds))
                    .build();
            System.out.println("S3 Client successfully initialized.");
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Error initializing S3 Client: " + e.getMessage());
        }
    }

    public String uploadFile(String fileName, String filePath) {
        try {
            Path path = Paths.get(filePath);
            PutObjectRequest putObjectRequest = PutObjectRequest.builder()
                    .bucket(bucket)
                    .key(fileName)
                    .build();

            PutObjectResponse putObjectResponse = s3Client.putObject(putObjectRequest, path);
            System.out.println("File uploaded to S3 successfully: " + putObjectResponse);

            return s3Client.utilities().getUrl(b -> b.bucket(bucket).key(fileName)).toExternalForm();
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Error uploading file to S3: " + e.getMessage());
            return null;
        }
    }
}
