/*
**************************************************************************************************************************************
Azure Bicep Template for Azure Log Analytics Workspace
**************************************************************************************************************************************
*/
/*****Paramters for Azure Log Analytics Workspace*****/
param loganalyticsworkspace string
param Location string

resource loganalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-10-01' = {
  name: loganalyticsworkspace
  location: Location
}
