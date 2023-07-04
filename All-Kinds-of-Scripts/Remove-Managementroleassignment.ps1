$roleassigment = (get-managementroleassignment "applicationimp*").name 

foreach ($name in $roleassigment) {
    Remove-Managementroleassignment $name
    else {
        Write-Host "Couldnt delete roleassignment"
    }
}