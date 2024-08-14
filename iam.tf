resource "aws_iam_instance_profile" "openaiflask" {
  name = "openaiflask-${random_string.rando.result}"
  role = aws_iam_role.openaiflask.name
}

resource "aws_iam_role" "openaiflask" {
  name = "openaiflask-${random_string.rando.result}"
    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
        {
            Effect = "Allow",
            Principal = {
            Service = "ec2.amazonaws.com"
            },
            Action = "sts:AssumeRole"
        }
        ]
    })

    tags = {
        Name = "openaiflask-${random_string.rando.result}"
    }

    inline_policy {
        name = "secrets-manager-policy"
        policy = jsonencode({
            Version = "2012-10-17",
            Statement = [
            {
                Effect = "Allow",
                Action = [
                "secretsmanager:GetResourcePolicy",
                "secretsmanager:GetSecretValue",
                "secretsmanager:DescribeSecret",
                "secretsmanager:ListSecretVersionIds"
                ],
                Resource = "*"
            }
            ]
        })
    }
}

resource "aws_iam_role_policy_attachment" "openaiflask-policy" {
  role = aws_iam_role.openaiflask.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}