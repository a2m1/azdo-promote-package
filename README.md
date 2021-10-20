# azdo-promote-artifacts
Promoting packages to th required view in Azure DevOps Artifacts

## Promote-Package.ps1
[Promote-Package](./Promote-Package.ps1) is a modified version of [VSTS-SetPackageQuality](https://github.com/renevanosnabrugge/VSTS-SetPackageQuality).
Usage example: `./Promote-Package.ps1 -feedName <yourfeed> -packageName <yourPackage> -packageVersion <versionToPromote> -targetView <targetView> -feedType <npm/nuget/python/universal>`

### Requirements
1. Environment Variables
  - `SYSTEM_TEAMFOUNDATIONSERVERURI` - Name os the Azure DevOps Organization. It's default Azure DevOps Variable
  - `SYSTEM_TEAMPROJECT` - Name of the Azure DevOps Project. It's default Azure DevOps Variable
  - `AZDO_PAT` - [Personal Access Token](https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=preview-page)
2. Personal Access Token should have _Packaging -> Manage_ permissions
3. Owner of the Personal Access Token should have _Contributor_ access to the feed
