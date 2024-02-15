# Load Windows Forms assembly
Add-Type -AssemblyName System.Windows.Forms

# Create form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Printer Connection Checker"
$form.Size = New-Object System.Drawing.Size(800, 400)
$form.AutoSize = $true
$form.AutoSizeMode = 'GrowAndShrink'

# Create TextBox for user input
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Multiline = $true
$textBox.Size = New-Object System.Drawing.Size(300, 50)
$textBox.Location = New-Object System.Drawing.Point(20, 20)
$form.Controls.Add($textBox)

# Create Button to add printers
$printerNamesArray = New-Object System.Collections.Generic.List[System.Object]

$addButton = New-Object System.Windows.Forms.Button
$addButton.Text = "Add Printer"
$addButton.Size = New-Object System.Drawing.Size(100, 30)
$addButton.Location = New-Object System.Drawing.Point(20, 80)
$addButton.Add_Click({
    try {
        $printerName = $textBox.Text -replace "`r`n", "`n" | ForEach-Object { $_.Trim() }
        if (-not [string]::IsNullOrWhiteSpace($printerName) -and $printerName -notlike "*validSubstring*") {
            $printerNamesArray.Add($printerName)
            $textBox.Clear()
            $label.Text += "`nPrinter $printerName added"
        } else {
            $label.Text += "Input incorrect printer name"
        }
    } catch {
        $label.Text += "Input incorrect printer name"
    }
})

$form.Controls.Add($addButton)

# Create Button to initiate check
$button = New-Object System.Windows.Forms.Button
$button.Text = "Check Printers"
$button.Size = New-Object System.Drawing.Size(100, 30)
$button.Location = New-Object System.Drawing.Point(20, 130)
$button.Add_Click({
    $label.Text = "Printer Names:`n" + ($printerNamesArray -join "`n")
    foreach ($printerName in $printerNamesArray) {
        # Check the connection for printer (modified to check for online status)
        $pingResult = Test-Connection -ComputerName $printerName -Count 1 -ErrorAction SilentlyContinue
        
        if ($pingResult -ne $null) {
            # Display the result in the Label
            $label.Text += "`nPrinter $printerName is online."
        } else {
            # Display the result in the Label
            $label.Text += "`nPrinter $printerName is offline."
        }

        # Wait for a short duration before the next iteration
        Start-Sleep -Seconds 3
    }
})
$form.Controls.Add($button)

# Create Cancel Button
$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Text = "Cancel"
$cancelButton.Size = New-Object System.Drawing.Size(100, 30)
$cancelButton.Location = New-Object System.Drawing.Point(140, 130)
$cancelButton.Add_Click({
    # Action to perform when the cancel button is clicked
    $form.Close()
})
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

# Create Label to display the result
$label = New-Object System.Windows.Forms.Label
$label.AutoSize = $true
$label.Location = New-Object System.Drawing.Point(20, 180)
$form.Controls.Add($label)

# Show the form
$form.ShowDialog()
