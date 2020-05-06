add-type -AssemblyName microsoft.VisualBasic
add-type -AssemblyName System.Windows.Forms


## GUI 
#基本のフォームを作成する
function makeForm
{
    param
    (
        [hashtable] $Callbacks,
        [string]$Title
    )
    #フォームの設定
    $form = New-Object System.Windows.Forms.Form
    $form.Size = "400,1000"
    $form.startposition = "centerscreen"
    $form.text = $Title
    $form.MaximizeBox = $False
    $form.MinimizeBox = $False
    $form.BackColor = "white"
    $form.AutoScroll = $True

    $ButtonwLoc = 10
    $ButtonhLoc = 10
    $ButtonName = "sample"

    $Button = $Callbacks["OnButtonMake"].Invoke($form,$ButtonwLoc,$ButtonhLoc,$ButtonName)
    $Dialog = $Callbacks["OnFileOpenDialog"].Invoke($form)

    # フォームを表示する
    $Form.Showdialog() 
}

$makeCallbacks = @{
    "OnButtonMake"  = { 
        # ボタンを作成
        $Button = New-Object System.Windows.Forms.Button
        # ボタンの表示場所を指定
        $Button.Location = New-Object System.Drawing.Size($args[1],$args[2])
        # ボタンのサイズを指定
        $Button.Size = New-Object System.Drawing.Size(300,100)
        # ボタンのデザイン color https://developer.mozilla.org/en-US/docs/Web/CSS/color_value
        $Button.BackColor = "white"
        $Button.FlatStyle = 2

        # ボタンに表示する文字列
        $Button.Text = $args[3]
        # ボタンをクリック
        $Button.Add_Click({ActiveWinAction})

        # ボタンを有効にする
        $args[0].Controls.Add($Button)
        return $Button
     }
}


###Action

#ファイルを読み込む
Function Fn_OpenFile(){
    
    #アセンブリのロード
    Add-Type -AssemblyName System.Windows.Forms

    #ダイアログインスタンス生成
    $dialog = New-Object Windows.Forms.OpenFileDialog
    
    #タイトル、選択可能ファイル拡張子、初期ディレクトリ
    $dialog.Title = "ファイルを選択"
    $dialog.Filter = "xml files (*.xml)|*.xml|All files (*.*)|*.*"
    $dialog.InitialDirectory = "C:\"
  
    #ダイアログ表示
    $result = $dialog.ShowDialog()

    #「開くボタン」押下ならファイル名フルパスをリターン
    If($result -eq "OK"){
        Return $dialog.FileName 
    }Else{
        Break
    }

}
#アクティブウインドウを設定する
function ActiveWinAction  ($processName = "chrome",$titleName = "PowerShell") {
    #対象プロセス名で取得プロセスをフィルタリング
    $psArray = [System.Diagnostics.Process]::GetProcesses() | Where-Object {$_.Name -eq $processName}
    #アクティブウインドウに変更
    foreach ($ps in $psArray){
        #タイトルがないものはスルー
        if($ps.MainWindowTitle.Contains($titleName)) {
                [String]$ps.Handles + " : " + $ps.MainWindowTitle
                # プロセスをアクティブにする 
                [Microsoft.VisualBasic.Interaction]::AppActivate($ps.ID);
        }
    }
}

## main
#ファイル取得
$file = Fn_OpenFile
makeForm -Callbacks $makeCallbacks  -Title ("Title")