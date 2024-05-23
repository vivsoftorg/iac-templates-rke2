data "aws_iam_policy_document" "sops_nodes_access" {
  count = var.enable_sops ? 1 : 0
  statement {
    sid = ""
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey"
    ]
    resources = [
      aws_kms_key.sops_key[count.index].arn
    ]
    effect = "Allow"
  }
}

resource "aws_iam_policy" "sops_nodes_access" {
  count  = var.enable_sops ? 1 : 0
  name   = "${local.name}-control-plane-sops"
  path   = "/"
  policy = data.aws_iam_policy_document.sops_nodes_access[count.index].json
  tags   = local.tags
}

resource "aws_iam_role_policy_attachment" "sops" {
  count      = var.enable_sops ? 1 : 0
  role       = module.rke2.iam_role
  policy_arn = aws_iam_policy.sops_nodes_access[count.index].arn
}

resource "aws_iam_role_policy_attachment" "sops_worker" {
  count      = var.enable_sops ? 1 : 0 == 1 ? 1 : 0
  role       = module.rke2_agents.iam_role
  policy_arn = aws_iam_policy.sops_nodes_access[count.index].arn
}

data "aws_iam_policy_document" "sops" {
  count = var.enable_sops ? 1 : 0
  statement {
    sid = "1"
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion"
    ]
    resources = [
      "*"
    ]
    principals {
      type = "AWS"
      identifiers = [
        local.current_arn
      ]
    }
    effect = "Allow"
  }
  statement {
    sid = "2"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = [
      "*"
    ]
    principals {
      type = "AWS"
      identifiers = [
        local.current_arn
      ]
    }
    effect = "Allow"
  }
  statement {
    sid = "3"
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey"
    ]
    resources = [
      "*"
    ]
    principals {
      type = "AWS"
      identifiers = [
        module.rke2.iam_role_arn,
        module.rke2_agents.iam_role_arn
      ]
    }
    effect = "Allow"
  }
}

resource "aws_kms_key" "sops_key" {
  count                   = var.enable_sops ? 1 : 0
  description             = "SOPS encrypt decrypt key"
  deletion_window_in_days = 7
  policy                  = data.aws_iam_policy_document.sops[count.index].json
  key_usage               = "ENCRYPT_DECRYPT"
  enable_key_rotation     = "true"
  tags                    = local.tags
}

resource "aws_kms_alias" "sops" {
  count         = var.enable_sops ? 1 : 0
  name          = "alias/${local.name}-sops"
  target_key_id = aws_kms_key.sops_key[count.index].key_id
}
