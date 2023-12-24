<#
========================================================================
CE SCRIPT PERMET D'AFFICHER L'AIDE POWERSHELL SOUS UNE INTERFACE GRAPHIQUE.

Il contient : Formulaire, bouton, label, treeview, menu contextuel.

#>
# 
$Auteur = "Guy Sacilotto"                                                  
$Date_creation = "08/11/2012"                                              
$Date_Update = "08/01/2013"												   
$Version = "1.02"                                                          
#========================================================================


#----------------------------------------------
#region Functions
#----------------------------------------------

	function Call-help_powershell{

		#----------------------------------------------
		#region Import des Assemblies
		#----------------------------------------------
			[void][reflection.assembly]::Load("System, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
			[void][reflection.assembly]::Load("System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
			[void][reflection.assembly]::Load("System.Drawing, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a")
			[void][reflection.assembly]::Load("mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
			[void][reflection.assembly]::Load("System.DirectoryServices, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a")
			[void][reflection.assembly]::Load("System.Core, Version=3.5.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
			[void][reflection.assembly]::Load("System.Data, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
			[void][reflection.assembly]::Load("System.Xml, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
		#----------------------------------------------
		#endregion Import des Assemblies
		#----------------------------------------------
		
		#----------------------------------------------
		#region Création des objets du formulaire
		#----------------------------------------------
			[System.Windows.Forms.Application]::EnableVisualStyles()
			$form1 = New-Object 'System.Windows.Forms.Form'								# Formulaire
			$splitcontainer1 = New-Object 'System.Windows.Forms.SplitContainer'			# Enveloppe des objets
			$LabelVersion = New-Object System.Windows.Forms.Label							# Label
			$buttonExit = New-Object 'System.Windows.Forms.Button'						# Bouton
			$TextBoxDetails = New-Object 'System.Windows.Forms.RichTextBox'				# TextBox
			$treeviewNav = New-Object 'System.Windows.Forms.TreeView'					# Treeview
			$imagelist1 = New-Object 'System.Windows.Forms.ImageList'					# Images pour le treeview
			$ContextMenu = New-Object System.Windows.Forms.ContextMenuStrip				# Menu contextuel
			$contextMenuItem =  New-Object System.Windows.Forms.ToolStripMenuItem		# Item du menu contextuel
		#----------------------------------------------
		#endregion Création des objets du formulaire
		#----------------------------------------------
		
		$FormEvent_Load={
			Load-TreeHelp
		}
		
		function Load-TreeHelp{
			$treeviewNav.BeginUpdate()
			$treeviewNav.Nodes.Clear()													# initialise de treeview.
			$Commands = Get-Command														# Permet d'alimenter le treeview.
			$Root = $treeviewNav.Nodes.Add("Commandes Powershell","Commandes Powershell", 1, 1)	# Texte du Premier niveau.
			$root.ToolTipText = "Liste des Commandes Powershell"						# infobulle du premier niveau.
			foreach($comande in $Commands)												# pour chaque commandes.
				{
				$node = $Root.Nodes.Add($comande.Name,$comande.Name,1 ,1)				# Texte affichée.
				$node.Tag = $comande													# information mémorisé sur le clic.
				$node.ToolTipText = "(" + $comande.CommandType + ") " + $comande.Name	# info bulle.
				
				if($comande.CommandType -eq 'Alias')
					{$node.StateImageIndex = 0 }										#affecte un image.
				elseif($comande.CommandType -eq 'Function')
					{$node.StateImageIndex = 1 }										#affecte un image.
				elseif($comande.CommandType -eq 'Cmdlet')
					{$node.StateImageIndex = 2 }										#affecte un image.
				else
					{$node.StateImageIndex = 3 }										#affecte un image.
				}
				
				$Root.Expand()															# développe le treeview.
				$treeviewNav.EndUpdate()
		}
		
		$treeviewNav_NodeMouseDoubleClick=[System.Windows.Forms.TreeNodeMouseClickEventHandler]{
			$comande = $_.Node.Tag
			if($comande -ne $null)
			{
				$TextBoxDetails.Text = Get-Help $comande -Full  | Out-String		# Affiche l'aide de la commande sélectionnée.
			}
		}
		
		#----------------------------------------------
		#region Genere le formulaire
		#----------------------------------------------
		#
		# form1
		#
		$form1.Controls.Add($splitcontainer1)			# affichage de conteneur
		$form1.Controls.Add($buttonExit)				# Affichage du bouton
		$form1.Controls.Add($LabelVersion)				# Affichage de la version
		$form1.ClientSize = '880, 600'					# Taille du formaulaire
		$form1.Name = "form1"							# Nom du formulaire
		$form1.StartPosition = 'CenterScreen'			# Position du formulaire sur l'écran
		$form1.Text = "Aide PowerShell"					# Titre du formulaire
		$form1.ShowInTaskbar = $true					# Visible dans la barre des tâches
		$form1.add_Load($FormEvent_Load)				# Action lors du chargement du formulaire
		#
		# splitcontainer1
		#
		$splitcontainer1.Anchor = 'Top, Bottom, Left, Right'
		$splitcontainer1.Location = '12, 12'
		$splitcontainer1.Name = "splitcontainer1"
		[void]$splitcontainer1.Panel1.Controls.Add($treeviewNav)
		[void]$splitcontainer1.Panel2.Controls.Add($TextBoxDetails)
		$splitcontainer1.Size = '840, 550'
		$splitcontainer1.SplitterDistance = 199
		$splitcontainer1.TabIndex = 3
		#
		# buttonExit
		#
		$buttonExit.DialogResult = 'Cancel'
		$buttonExit.Anchor = 'Bottom, Right'
		$buttonExit.Location = '760, 570'
		$buttonExit.Name = "buttonExit"
		$buttonExit.Size = '75, 23'
		$buttonExit.TabIndex = 2
		$buttonExit.Text = "Quitter"
		$buttonExit.UseVisualStyleBackColor = $True
		#
		# listviewDetails
		#
		$TextBoxDetails.Dock = 'Fill'
		$TextBoxDetails.Location = '0, 0'
		$TextBoxDetails.Name = "listviewDetails"
		$TextBoxDetails.Size = '413, 341'
		$TextBoxDetails.TabIndex = 1
		$TextBoxDetails.text = ""
		$TextBoxDetails.BackColor = "white"
		$TextBoxDetails.BorderStyle = "Fixed3D"
		$TextBoxDetails.Multiline = $true
		$TextBoxDetails.ReadOnly = $true
		$TextBoxDetails.WordWrap = $true
		#
		# treeviewNav
		#
		$treeviewNav.Anchor = 'Top, Bottom, Left, Right'
		$treeviewNav.Location = '0, 0'
		$treeviewNav.Size = '189, 570'
		$treeviewNav.Name = "treeviewNav"
		$treeviewNav.ShowNodeToolTips = $True
		$treeviewNav.ShowRootLines = $False
		$treeviewNav.StateImageList = $imagelist1
		$treeviewNav.TabIndex = 0
		$treeviewNav.ImageIndex = 0
		$treeviewNav.SelectedImageIndex = 0
		#$treeviewNav.add_NodeMouseDoubleClick($treeviewNav_NodeMouseDoubleClick)
		$treeviewNav.add_NodeMouseClick($treeviewNav_NodeMouseDoubleClick)
		#
		# context Menu
		#	
		$contextMenuItem.Name = "Refresh" 
		$contextMenuItem.Text = "Refresh" 
		$contextMenuItem.ShortcutKeys = [System.Windows.Forms.Keys]::F5 
		
		$contextMenu.Items.Add($contextMenuItem) 

		$contextMenuItem_Click =  { 
	    	$treeviewNav.Nodes.Clear() 
	    	#$treeviewNav.Items.Clear() 
	    	Load-TreeHelp 
		} 
	 
		$contextmenuItem.Add_Click($contextMenuItem_Click)
		$form1.ContextMenuStrip = $contextMenu
		[System.Windows.Forms.Application]::EnableVisualStyles()
		
		#
		# LabelVersion
		#
		$LabelVersion.Anchor = 'Bottom, left'
		$LabelVersion.location = New-Object System.Drawing.Point(20,580)						# Positionnement du label
		$LabelVersion.autosize = $True
		$LabelVersion.BackColor = "Transparent"													# Couleur du fond de la zone
		$LabelVersion.name = "LabelVersion"														# Nom de la zone
		$LabelVersion.Text = $Auteur + " Version : $Version " + " du : $Date_Update"			# contenu de la zone
		
		#----------------------------------------------
		#endregion Genere le formulaire
		#----------------------------------------------
		
		#----------------------------------------------
		#region Création des images
		#----------------------------------------------
		# imagelist1
		$Formatter_binaryFomatter = New-Object System.Runtime.Serialization.Formatters.Binary.BinaryFormatter
		$System_IO_MemoryStream = New-Object System.IO.MemoryStream (,[byte[]][System.Convert]::FromBase64String('AAEAAAD/////AQAAAAAAAAAMAgAAAFdTeXN0ZW0uV2luZG93cy5Gb3JtcywgVmVyc2lvbj0yLjAu
	MC4wLCBDdWx0dXJlPW5ldXRyYWwsIFB1YmxpY0tleVRva2VuPWI3N2E1YzU2MTkzNGUwODkFAQAA
	ACZTeXN0ZW0uV2luZG93cy5Gb3Jtcy5JbWFnZUxpc3RTdHJlYW1lcgEAAAAERGF0YQcCAgAAAAkD
	AAAADwMAAACYBQAAAk1TRnQBSQFMAgEBAwEAAVgBAAFYAQABEAEAARABAAT/ASEBAAj/AUIBTQE2
	BwABNgMAASgDAAFAAwABEAMAAQEBAAEgBgABEP8A/wAsAAEFAVUBBQH//AABBQFdARUB/wEAAVUB
	BQH/+AABFQFlARUB/wEVAWUBJQH/AQABVQEFAf8sAAEWARkB7AH/AQsBDAHaAf8BCgELAdoB/wEI
	AQoB2gH/AQgBCgHaAf8BCQEKAdoB/wEKAQsB2gH/AQkBDAHQAf8kAAHeAZsBawH/AYABJQEAAf8B
	gAElAQAB/wQAAd4BmwFrAf8BgAElAQAB/wGAASUBAAH/aAABFQFtASUB/wElAYABNQH/ARUBZQEl
	Af8BAAFVAQUB/ygAASkBKwL/AQ0BCwL/AQoBCQL/AQcBBgL/AQYBBQL/AgcC/wELAQkC/wEOAREB
	7gH/JAAB4AGYAWUB/wHwAcABoAH/AYABJQEAAf8EAAHgAZgBZQH/AfABwAGgAf8BgAElAQAB/2gA
	ASUBgAElAf8BRQGgAVUB/wElAYABNQH/ARUBZQElAf8BAAFVAQUB/yQAASgBKgL/AQoBCQL/AQYB
	BQL/AQEBAAL/AgAC/wECAQEC/wEIAQcC/wENAQ8B7QH/JAAB4AGYAWUC/wHIAbAB/wGAASUBBQH/
	BAAB4AGYAWUC/wHIAbAB/wGAASUBBQH/aAABNQGAATUB/wFVAbABZQH/AUUBoAFVAf8BJQGAATUB
	/wEVAWUBJQH/AQUBXQEVAf8gAAEnASkB/QH/AQoBCAL/AgQC/wIAAv8CAAL/AgAC/wEHAQYC/wEM
	AQ4B7QH/JAAB8AGgAYAC/wHQAcAB/wGQAS0BBQH/BAAB8AGgAYAC/wHQAcAB/wGQAS0BBQH/aAAB
	NQGIAUUB/wFlAcABZQH/AWUBwAFlAf8BRQGgAVUB/wElAW0BNQH/JAABKAEqAv8BCgEJAv8BBgEF
	Av8BAQEAAv8CAAL/AQIBAQL/AQgBBwL/AQ0BDwHtAf8kAAHwAaABgAL/AdgB0AH/AZABNQEFAf8E
	AAHwAaABgAL/AdgB0AH/AZABNQEFAf9oAAFFAZABRQH/AWUBwAFlAf8BoAHYAbAB/wElAW0BNQH/
	KAABKQEqAv8BDQELAv8BCQEIAv8BBgEFAv8CBQL/AQcBBgL/AQsBCQL/AQ4BEAHtAf8kAAHwAagB
	gAL/AeAB0AH/AaABPQEVAf8EAAHwAagBgAL/AeAB0AH/AaABPQEVAf9oAAFFAZgBVQH/AaAB2AGw
	Af8BJQFtATUB/ywAASgBKgL/AQ0BCwL/AQwBCwL/AQoBCQL/AQoBCQL/AQoBCQL/AQ0BCwL/AQ4B
	EAHtAf8kAAHwAbABgAL/AegB4AH/AaABRQEVAf8EAAHwAbABgAL/AegB4AH/AaABRQEVAf9oAAFV
	AZgBVQH/ASUBbQE1Af8wAAFKAUsC/wI3Av8CNwL/AjYC/wI2Av8CNwL/AjgC/wEnASkB/QH/JAAB
	/wGwAZAC/wHgAdAB/wGwAU0BJQH/BAAB/wGwAZAC/wHgAdAB/wGwAU0BJQH/aAABVQGYAVUB/3gA
	Af8BsAGQAv8BsAGQAf8B4AGcAWwB/wQAAf8BsAGQAv8BsAGQAf8B4AGcAWwB//8A/wD/AFMAAUIB
	TQE+BwABPgMAASgDAAFAAwABEAMAAQEBAAEBBQABgBcAA/8BAAb/AgAG/wIAAf0F/wIAAfwF/wIA
	AfwBfwHwAQ8B+AGPAgAB/AE/AfABDwH4AY8CAAH8AR8B8AEPAfgBjwIAAfwBDwHwAQ8B+AGPAgAB
	/AEfAfABDwH4AY8CAAH8AT8B8AEPAfgBjwIAAfwBfwHwAQ8B+AGPAgAB/AH/AfABDwH4AY8CAAH9
	A/8B+AGPAgAG/wIABv8CAAb/AgAL'))
		
		$imagelist1.ImageStream = $Formatter_binaryFomatter.Deserialize($System_IO_MemoryStream)
		$Formatter_binaryFomatter = $null
		$System_IO_MemoryStream = $null
		$imagelist1.TransparentColor = 'Transparent'
		#----------------------------------------------
		#endregion Création des images
		#----------------------------------------------

		return $form1.ShowDialog()

	} 
#----------------------------------------------
#Endregion Function
#----------------------------------------------

#----------------------------------------------
#region Debut du script
#----------------------------------------------
	Call-help_powershell | Out-Null
#----------------------------------------------
#endregion Debut du script
#----------------------------------------------	