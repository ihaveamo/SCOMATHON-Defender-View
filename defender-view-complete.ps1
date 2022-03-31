#Scomathon Demo Defender view
#Place in a powershell gridview widget
#Author - Michael Forde
#V1.0
#31/3/22

$allEndpoints= get-scomclass -DisplayName "Protected Endpoint" | where {$_.ManagementPackName -match "Microsoft.WindowsDefender"} | Get-SCOMClassInstance | Select *

foreach ($endpoint in $allEndpoints){
    $dataObject = $ScriptContext.CreateInstance("xsd://www.scomathon.com/MySchema");
    $linedata++;
        
    
    $dataObject["Id"]=[string]$linedata;
    $dataObject["Name"]=$endpoint.'[Microsoft.WindowsDefender.ProtectedServer].ServerId'.value;


    if ($endpoint.'[Microsoft.WindowsDefender.ProtectedServer].AMStatus'.value -eq "true") {$StateIcon=1} else {$StateIcon=3}
        $dataObject["Defender Enabled"]=$ScriptContext.CreateWellKnownType("xsd://Microsoft.SystemCenter.Visualization.Library!Microsoft.SystemCenter.Visualization.OperationalDataTypes/MonitoringObjectHealthStateType",$StateIcon)        
    
    if ($endpoint.'[Microsoft.WindowsDefender.ProtectedServer].RTPStatus'.value -eq "true") {$StateIcon=1} else {$StateIcon=3}
        $dataObject["Real Time Protection Enabled"]= $ScriptContext.CreateWellKnownType("xsd://Microsoft.SystemCenter.Visualization.Library!Microsoft.SystemCenter.Visualization.OperationalDataTypes/MonitoringObjectHealthStateType",$StateIcon)


    if ($endpoint.'[Microsoft.WindowsDefender.ProtectedServer].RTPDirection'.value -eq "Both incoming and outcoming") {$StateValue="Both In & Out"} else {$StateValue=$endpoint.'[Microsoft.WindowsDefender.ProtectedServer].RTPDirection'.value}
        $dataObject["Real Time Protection Direction"]=$StateValue;


    $dataObject["Last Quick Scan (Days)"]= $endpoint.'[Microsoft.WindowsDefender.ProtectedServer].LastQuickScanAge'.value;
    $dataObject["Last Full Scan (Days)"]=$endpoint.'[Microsoft.WindowsDefender.ProtectedServer].LastFullScanAge'.value;
    $dataObject["Client Version"]= $endpoint.'[Microsoft.WindowsDefender.ProtectedServer].ClientVer'.Value;
    $dataObject["AV Definition Version"]=$endpoint.'[Microsoft.WindowsDefender.ProtectedServer].AVSigsVer'.value;
    $dataObject["Network Inspection Definition Version"]=$endpoint.'[Microsoft.WindowsDefender.ProtectedServer].NISSigsVer'.value;
    $dataObject["AntiSpyWare Version"]=$endpoint.'[Microsoft.WindowsDefender.ProtectedServer].ASSigsVer'.value;
    $dataObject["AV Definition Age (Days)"]=$endpoint.'[Microsoft.WindowsDefender.ProtectedServer].AVSigsAge'.value;


    if ($endpoint.'[Microsoft.WindowsDefender.ProtectedServer].LastFullScanAge'.value -eq "Never Scanned Before")  {$StateIcon=2}
    elseif ([int]$endpoint.'[Microsoft.WindowsDefender.ProtectedServer].LastFullScanAge'.value -lt 8) {$StateIcon=1} else {$StateIcon=3}

    $dataObject["LastFullScanState"]=$ScriptContext.CreateWellKnownType("xsd://Microsoft.SystemCenter.Visualization.Library!Microsoft.SystemCenter.Visualization.OperationalDataTypes/MonitoringObjectHealthStateType",$StateIcon)


    if ($endpoint.'[Microsoft.WindowsDefender.ProtectedServer].LastQuickScanAge'.value -eq "Never Scanned Before")  {$StateIcon=2}
    elseif ([int]$endpoint.'[Microsoft.WindowsDefender.ProtectedServer].LastQuickScanAge'.value -lt 2) {$StateIcon=1} else {$StateIcon=3}
    
    $dataObject["LastQuickScanState"]=$ScriptContext.CreateWellKnownType("xsd://Microsoft.SystemCenter.Visualization.Library!Microsoft.SystemCenter.Visualization.OperationalDataTypes/MonitoringObjectHealthStateType",$StateIcon)
        

    if ($endpoint.'[Microsoft.WindowsDefender.ProtectedServer].AVSigsAge'.value -eq 0)  {$StateIcon=1} else {StateIcon=3}
    $dataObject["AVDefinitionState"]=$ScriptContext.CreateWellKnownType("xsd://Microsoft.SystemCenter.Visualization.Library!Microsoft.SystemCenter.Visualization.OperationalDataTypes/MonitoringObjectHealthStateType",$StateIcon)
    
    $ScriptContext.ReturnCollection.Add($dataObject); 

}
