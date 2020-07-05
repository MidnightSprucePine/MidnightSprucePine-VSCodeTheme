<#
.SYNOPSIS
Provisions a example powershell function
.EXAMPLE
PS C:\> .\powershell.ps1 -Argument1 "Hello World"
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, HelpMessage = "This argument is required")]
    [String]
    $textParameter
)

try {
    #almost every function is called like this:
    Write-Host "Initializing example function"
    Write-Host "The parameter is " $textParameter -ForegroundColor Red

    #this are variables
    $customArray = @(
        @{
            Id    = 1;
            Value = "I'm an option";
        },
        @{
            Id    = 2;
            Value = "Option No. 2";
        }
    )

    foreach ($option in $customArray) {
        Write-Host "Iterating options:" $option.Value
    }

    $collectionWithItems = New-Object System.Collections.ArrayList
    $temp = New-Object System.Object
    $temp | Add-Member -MemberType NoteProperty -Name "Title" -Value "Custom Object Title 1"
    $temp | Add-Member -MemberType NoteProperty -Name "Subject" -Value "Plan of action [Folio_ActionPlan]"
    $temp | Add-Member -MemberType NoteProperty -Name "Body" -Value "<div>This is a note example, with lots of text</div>
      <div> <br/>&#160;</div>
      <div>It is in html format.<br/></div>
      <div><br/>&#160;<br/></div>
      <div>To render <a href='/thePlanOfAction'>OR not to render.</a></div>"
    $collectionWithItems.Add($temp) | Out-Null
    Write-Host "My collection has" $collectionWithItems.Count "item(s)" -ForegroundColor Green

    #Calling some other scripts. Sometimes its nice to have a "master" script and call subscripts with other functions / actions
    .\otherscript.ps1 "Parameter ?"
    .\thisonewithoutparams.ps1

    #little bit of SharePoint *the original issue* :D
    $web = Get-SPWeb http://mysharepointsite
    $list = $web.Lists["ListName"]
    $query = New-Object Microsoft.SharePoint.SPQuery
    $query.Query= "CAMLQuery here"
    $query.ViewFields= "<FieldRef Name='ID'/><FieldRef Name='Title'/>"
    $query.ViewFieldsOnly= $true
    $listitems = $list.GetItems($query);
    foreach($item in $listitems) {
      if($item -ne $null) {
        Write-Host "There is an elemeent in the list, id" $item.ID
      }
    }
}
catch {
    Write-Host -ForegroundColor Red "Exception Type: $($_.Exception.GetType().FullName)"
    Write-Host -ForegroundColor Red "Exception Message: $($_.Exception.Message)"
}
