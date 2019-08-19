import * as cdk from '@aws-cdk/core'
import * as ecr from '@aws-cdk/aws-ecr'
import * as iam from '@aws-cdk/aws-iam'

//
// pure 
export type IaaC<T> = (parent: cdk.Construct) => T

export function _<T>(parent: cdk.Construct, ...fns: Array<IaaC<T>>): cdk.Construct {
  fns.forEach(
    fn => {
    parent instanceof cdk.App 
      ? fn(new cdk.Stack(parent, fn.name))
      : fn(new cdk.Construct(parent, fn.name))
    }
  )
  return parent
}

function policy(): iam.PolicyStatement {
   const policy = new iam.PolicyStatement()
   policy.addPrincipals(new iam.ServicePrincipal('codebuild.amazonaws.com'))
   policy.addActions(
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability"
   )
   return policy
}

function CodeBuildServerless(parent: cdk.Construct): cdk.Construct {
   const repo = new ecr.Repository(parent, 'Repo', {
      repositoryName: process.env.REPO
   })
   repo.addToResourcePolicy(policy())
   return repo
}


const app = new cdk.App()
_(app, CodeBuildServerless)
app.synth()
