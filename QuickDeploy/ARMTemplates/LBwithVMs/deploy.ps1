#Connect-AzAccount

$projectName = Read-Host -Prompt "Enter a project name with 12 or less letters or numbers that is used to generate Azure resource names"
$location = Read-Host -Prompt "Enter the location (i.e. northeurope)"
$adminUserName = Read-Host -Prompt "Enter the virtual machine administrator account name"
$adminPassword = Read-Host -Prompt "Enter the virtual machine administrator password" -AsSecureString

$PSScriptRoot

$resourceGroupName = "${projectName}rg"
$templateUri = "$($PSScriptRoot)\template.json"    

$additionalParameters = @{

    adminUsername = $adminUserName
    projectName = $projectName
    adminPassword = $adminPassword
    location = $location
}


New-AzResourceGroup -Name $resourceGroupName -Location $location
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateUri $templateUri @additionalParameters 

Write-Host "Press [ENTER] to continue."