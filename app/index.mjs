import { readFileSync } from "node:fs";

// Written by the deploy workflow, absent until the first pipeline run
const deploy = (() => {
  try {
    return JSON.parse(readFileSync(new URL("./deploy.json", import.meta.url), "utf8"));
  } catch {
    return { note: "Not deployed by the pipeline yet, push to main" };
  }
})();

export const handler = async () => ({
  message: "Deployed to AWS with zero stored keys",
  deploy,
  function: {
    name: process.env.AWS_LAMBDA_FUNCTION_NAME,
    region: process.env.AWS_REGION,
    runtime: process.env.AWS_EXECUTION_ENV,
  },
  howItWorked: [
    "The workflow asked GitHub for a signed OIDC token (permissions: id-token: write)",
    "AWS STS checked the token's aud and sub against the gha-deploy role's trust policy",
    "STS returned temporary credentials that expire in 15 minutes",
    "The workflow called lambda:UpdateFunctionCode with them, the only action the role allows",
    "CloudTrail logged the AssumeRoleWithWebIdentity call with the oidcSubject below",
  ],
  learnMore: "https://github.com/amaanx86/gha-aws-oidc-template",
});
