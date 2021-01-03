#!/usr/bin/env pwsh

param (
    [Parameter(
            Mandatory = $true,
            HelpMessage = "azureServiceConnectionName is a lowercase, alphanumeric name, starting with a letter.")]
    [ValidatePattern('(?-i:^[A-Za-z_0-9\-]+$)')]
    [string]
    $azureServiceConnectionName,

    [Parameter(
            Mandatory = $true,
            HelpMessage = "EnvironmentName is a lowercase, alphanumeric name, starting with a letter.")]
    [ValidatePattern('(?-i:^[a-z][a-z0-9]+$)')]
    [string]
    $environmentName,

    [Parameter(
            Mandatory = $true,
            HelpMessage = "Prefix is a lowercase, alphanumeric name, starting with a letter.")]
    [ValidatePattern('(?-i:^[a-z][a-z0-9]+$)')]
    [string]
   $prefix,

    [Parameter(Mandatory = $true)][string]$path,
    [Parameter(Mandatory = $true)][string]$varFile
)

Write-Host "Parameters verified."