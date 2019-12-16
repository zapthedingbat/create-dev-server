# Create an automation user in AWS

- Log into the AWS console as a user with administrative control.
- Go to
  [Identity and Access Management (IAM)](https://console.aws.amazon.com/iam/home#/users)
  in the console.
- Click **Add user** and create a user with the username `automation`. Check the
  _Programmatic access_ option but don't enable _AWS Management Console access_.
- In ther permissions step select _Attach existing policies directly_ and choose
  _AdministratorAccess_
- Record the _Access key ID_ and _Secret access key_ securly.
