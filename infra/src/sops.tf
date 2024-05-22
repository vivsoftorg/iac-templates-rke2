// data "aws_iam_policy_document" "sops_nodes_access" {
//   count = local.enable_sops
//   statement {
//     sid = ""
//     actions = [
//       "kms:Decrypt",
//       "kms:DescribeKey"
//     ]
//     resources = [
//       aws_kms_key.sops_key[count.index].arn
//     ]
//     effect = "Allow"
//   }
// }

// resource "aws_iam_policy" "sops_nodes_access" {
//   count  = local.enable_sops
//   name   = "${var.stack_prefix}-control-plane-sops"
//   path   = "/"
//   policy = data.aws_iam_policy_document.sops_nodes_access[count.index].json
//   tags = merge(var.resource_tags, {
//     "Name" = "${var.stack_prefix}-control-plane-sops"
//   })
// }

// resource "aws_iam_role_policy_attachment" "sops" {
//   count      = local.enable_sops
//   role       = aws_iam_role.control_plane.name
//   policy_arn = aws_iam_policy.sops_nodes_access[count.index].arn
// }

// resource "aws_iam_role_policy_attachment" "sops_worker" {
//   count      = (local.enable_sops == 1 && local.enable_workers == 1) ? 1 : 0
//   role       = aws_iam_role.worker[count.index].name
//   policy_arn = aws_iam_policy.sops_nodes_access[count.index].arn
// }

// data "aws_iam_policy_document" "sops" {
//   count = local.enable_sops
//   statement {
//     sid = "1"
//     actions = [
//       "kms:Create*",
//       "kms:Describe*",
//       "kms:Enable*",
//       "kms:List*",
//       "kms:Put*",
//       "kms:Update*",
//       "kms:Revoke*",
//       "kms:Disable*",
//       "kms:Get*",
//       "kms:Delete*",
//       "kms:TagResource",
//       "kms:UntagResource",
//       "kms:ScheduleKeyDeletion",
//       "kms:CancelKeyDeletion"
//     ]
//     resources = [
//       "*"
//     ]
//     principals {
//       type = "AWS"
//       identifiers = [
//         local.kms_admin_arn,
//         local.current_arn
//       ]
//     }
//     effect = "Allow"
//   }
//   statement {
//     sid = "2"
//     actions = [
//       "kms:Encrypt",
//       "kms:Decrypt",
//       "kms:ReEncrypt*",
//       "kms:GenerateDataKey*",
//       "kms:DescribeKey"
//     ]
//     resources = [
//       "*"
//     ]
//     principals {
//       type = "AWS"
//       identifiers = [
//         local.current_arn,
//         local.kms_admin_arn
//       ]
//     }
//     effect = "Allow"
//   }
//   statement {
//     sid = "3"
//     actions = [
//       "kms:Decrypt",
//       "kms:DescribeKey"
//     ]
//     resources = [
//       "*"
//     ]
//     principals {
//       type = "AWS"
//       identifiers = [
//         aws_iam_role.control_plane.arn,
//         aws_iam_role.worker[0].arn
//       ]
//     }
//     effect = "Allow"
//   }
// }

// resource "aws_kms_key" "sops_key" {
//   count                   = local.enable_sops
//   description             = "SOPS encrypt decrypt key"
//   deletion_window_in_days = 7
//   policy                  = data.aws_iam_policy_document.sops[count.index].json
//   key_usage               = "ENCRYPT_DECRYPT"
//   enable_key_rotation     = "true"
//   tags = merge(var.resource_tags, {
//     "Name" = "${var.stack_prefix}-sops-key"
//   })
// }

// resource "aws_kms_alias" "sops" {
//   count         = local.enable_sops
//   name          = "alias/${var.stack_prefix}-sops"
//   target_key_id = aws_kms_key.sops_key[count.index].key_id
// }

// resource "local_file" "sops_config" {
//   count = local.enable_sops
//   content = templatefile("${path.module}/templates/sops-config.yaml.tpl", {
//     kms_key_arn = aws_kms_key.sops_key[0].arn
//   })
//   filename             = "${path.module}/target/sops.yaml"
//   file_permission      = "0640"
//   directory_permission = "0750"
// }
