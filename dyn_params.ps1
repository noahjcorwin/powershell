function Test-DynParams {
    [CmdletBinding()]
    param ()

    DynamicParam {

        $array = @('one','two','three')

        $rtparamdic = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary  
        
        $param_list = 'list'
        $attribcoll = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $paramattrib = New-Object System.Management.Automation.ParameterAttribute
        $paramattrib.Mandatory = $true
        $paramattrib.Position = 0
        $attribcoll.Add($paramattrib)
        $valsetattrib = New-Object System.Management.Automation.ValidateSetAttribute($array)
        $attribcoll.Add($valsetattrib)
        $rtparam = New-Object System.Management.Automation.RuntimeDefinedParameter($param_list, [string], $attribColl)
        $rtparamdic.Add($param_list,$rtparam)
        
        return $rtparamdic
          
    }

}
