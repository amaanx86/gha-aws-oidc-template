# bootstrap

One-time, locally applied Terraform that creates everything the pipeline needs and nothing
the pipeline can change: the GitHub OIDC provider (optional), the `gha-deploy` role, and the
demo Lambda function with a public function URL. See the [root README](../README.md) for usage.

Built on [terraform-aws-modules](https://registry.terraform.io/namespaces/terraform-aws-modules),
pinned to exact versions: `iam` 6.8.2 (`iam-oidc-provider`, `iam-role`) and `lambda` 8.13.0.
Dependabot proposes upgrades as pull requests.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| terraform | >= 1.10.0 |
| archive | 2.8.1 |
| aws | 6.73.0 |
| external | 2.4.2 |
| local | 2.9.1 |
| null | 3.3.2 |
| tls | 4.4.2 |

## Providers

| Name | Version |
| ---- | ------- |
| archive | 2.8.1 |
| aws | 6.73.0 |

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| gha\_deploy\_role | terraform-aws-modules/iam/aws//modules/iam-role | 6.8.2 |
| github\_oidc\_provider | terraform-aws-modules/iam/aws//modules/iam-oidc-provider | 6.8.2 |
| lambda | terraform-aws-modules/lambda/aws | 8.13.0 |

## Resources

| Name | Type |
| ---- | ---- |
| [archive_file.bootstrap](https://registry.terraform.io/providers/hashicorp/archive/2.8.1/docs/data-sources/file) | data source |
| [aws_iam_openid_connect_provider.github](https://registry.terraform.io/providers/hashicorp/aws/6.73.0/docs/data-sources/iam_openid_connect_provider) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| account\_id | AWS account ID the stack is allowed to run against. | `string` | n/a | yes |
| github\_repository | GitHub repository allowed to assume the deploy role, as owner/name. | `string` | n/a | yes |
| create\_oidc\_provider | Create the GitHub OIDC provider. Set to false when the account already has one:<br/>IAM allows only one provider per issuer URL, and a provider owned by this stack<br/>would be deleted on destroy, breaking every other pipeline that relies on it. | `bool` | `true` | no |
| project | Project name, used as the prefix for resource names. | `string` | `"zero-keys"` | no |
| region | AWS region for the demo Lambda function. | `string` | `"eu-west-3"` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| deploy\_role\_arn | Role ARN for the AWS\_ROLE\_ARN repository variable. Not a secret. |
| deploy\_role\_subject | The only OIDC sub claim the deploy role accepts. |
| function\_name | Lambda function the pipeline deploys to (FUNCTION\_NAME repository variable). |
| function\_url | Public URL of the demo function. |
| oidc\_provider\_arn | GitHub OIDC provider the deploy role trusts. |
<!-- END_TF_DOCS -->
