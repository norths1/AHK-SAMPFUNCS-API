/*
	AHK-SAMPFUNCS-API
	
	MIT License

	Copyright (c) 2018 Rinat_Namazov

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
*/

; WinApi functions.
GetProcAddress(hModule, lpProcName)
{
	return DllCall("kernel32.dll\GetProcAddress", "UInt", hModule, "AStr", lpProcName)
}

GetModuleHandle(lpModuleName)
{
	return DllCall("kernel32.dll\GetModuleHandle", "Str", lpModuleName)
}

LoadLibrary(lpModuleName)
{
	return DllCall("kernel32.dll\LoadLibrary", "Str", lpModuleName)
}

DecToHex(num)
{
	if num is not integer
		return num
	loop
	{
		numb := Mod(num, 16)
		hn := numb == 10 ? "A"
			: numb == 11 ? "B"
			: numb == 12 ? "C"
			: numb == 13 ? "D"
			: numb == 14 ? "E"
			: numb == 15 ? "F"
			: numb
		hex_val := hn . hex_val
		if (!num := num // 16)
		{
			hex_val := "0x" . hex_val
			break
		}
	}
	return hex_val
}

GetParamsAsStr(ByRef params)
{
	VarSetCapacity(out, DllCall("lstrlen", "UInt", params))
	DllCall("lstrcpy", "Str", out, "UInt", params)
	params := out
}

class SAMPFUNCS
{
	; detour_types_s
	static DETOUR_TYPE_NOT_SET						:= -1
	static DETOUR_TYPE_JMP							:= 0
	static DETOUR_TYPE_PUSH_RET						:= 1
	static DETOUR_TYPE_PUSH_FUNC					:= 2
	static DETOUR_TYPE_CALL_FUNC					:= 3

	; WndProcCallbackPriority
	static HIGH_CB_PRIORITY							:= 0
	static MEDIUM_CB_PRIORITY						:= 1
	static LOW_CB_PRIORITY							:= 2
	static NUMBER_OF_CB_PRIORITIES					:= 3

	; RakNetScriptHookType
	static RAKHOOK_TYPE_OUTCOMING_RPC				:= 0
	static RAKHOOK_TYPE_OUTCOMING_PACKET			:= 1
	static RAKHOOK_TYPE_INCOMING_RPC				:= 2
	static RAKHOOK_TYPE_INCOMING_PACKET				:= 3
	static RAKHOOK_TOTAL_COUNT						:= 4

	; DIALOG_STYLES
	static DIALOG_STYLE_MSGBOX						:= 0
	static DIALOG_STYLE_INPUT						:= 1
	static DIALOG_STYLE_LIST						:= 2
	static DIALOG_STYLE_PASSWORD					:= 3
	static DIALOG_STYLE_TABLIST						:= 4
	static DIALOG_STYLE_TABLIST_HEADERS				:= 5

	; eDirect3DDeviceMethods
	static D3DMETHOD_QUERYINTERFACE					:= 0
	static D3DMETHOD_ADDREF							:= 1
	static D3DMETHOD_RELEASE						:= 2
	static D3DMETHOD_TESTCOOPERATIVELEVEL			:= 3
	static D3DMETHOD_GETAVAILABLETEXTUREMEM			:= 4
	static D3DMETHOD_EVICTMANAGEDRESOURCES			:= 5
	static D3DMETHOD_GETDIRECT3D					:= 6
	static D3DMETHOD_GETDEVICECAPS					:= 7
	static D3DMETHOD_GETDISPLAYMODE					:= 8
	static D3DMETHOD_GETCREATIONPARAMETERS			:= 9
	static D3DMETHOD_SETCURSORPROPERTIES			:= 10
	static D3DMETHOD_SETCURSORPOSITION				:= 11
	static D3DMETHOD_SHOWCURSOR						:= 12
	static D3DMETHOD_CREATEADDITIONALSWAPCHAIN		:= 13
	static D3DMETHOD_GETSWAPCHAIN					:= 14
	static D3DMETHOD_GETNUMBEROFSWAPCHAINS			:= 15
	static D3DMETHOD_RESET							:= 16
	static D3DMETHOD_PRESENT						:= 17
	static D3DMETHOD_GETBACKBUFFER					:= 18
	static D3DMETHOD_GETRASTERSTATUS				:= 19
	static D3DMETHOD_SETDIALOGBOXMODE				:= 20
	static D3DMETHOD_SETGAMMARAMP					:= 21
	static D3DMETHOD_GETGAMMARAMP					:= 22
	static D3DMETHOD_CREATETEXTURE					:= 23
	static D3DMETHOD_CREATEVOLUMETEXTURE			:= 24
	static D3DMETHOD_CREATECUBETEXTURE				:= 25
	static D3DMETHOD_CREATEVERTEXBUFFER				:= 26
	static D3DMETHOD_CREATEINDEXBUFFER				:= 27
	static D3DMETHOD_CREATERENDERTARGET				:= 28
	static D3DMETHOD_CREATEDEPTHSTENCILSURFACE		:= 29
	static D3DMETHOD_UPDATESURFACE					:= 30
	static D3DMETHOD_UPDATETEXTURE					:= 31
	static D3DMETHOD_GETRENDERTARGETDATA			:= 32
	static D3DMETHOD_GETFRONTBUFFERDATA				:= 33
	static D3DMETHOD_STRETCHRECT					:= 34
	static D3DMETHOD_COLORFILL						:= 35
	static D3DMETHOD_CREATEOFFSCREENPLAINSURFACE	:= 36
	static D3DMETHOD_SETRENDERTARGET				:= 37
	static D3DMETHOD_GETRENDERTARGET				:= 38
	static D3DMETHOD_SETDEPTHSTENCILSURFACE			:= 39
	static D3DMETHOD_GETDEPTHSTENCILSURFACE			:= 40
	static D3DMETHOD_BEGINSCENE						:= 41
	static D3DMETHOD_ENDSCENE						:= 42
	static D3DMETHOD_CLEAR							:= 43
	static D3DMETHOD_SETTRANSFORM					:= 44
	static D3DMETHOD_GETTRANSFORM					:= 45
	static D3DMETHOD_MULTIPLYTRANSFORM				:= 46
	static D3DMETHOD_SETVIEWPORT					:= 47
	static D3DMETHOD_GETVIEWPORT					:= 48
	static D3DMETHOD_SETMATERIAL					:= 49
	static D3DMETHOD_GETMATERIAL					:= 50
	static D3DMETHOD_SETLIGHT						:= 51
	static D3DMETHOD_GETLIGHT						:= 52
	static D3DMETHOD_LIGHTENABLE					:= 53
	static D3DMETHOD_GETLIGHTENABLE					:= 54
	static D3DMETHOD_SETCLIPPLANE					:= 55
	static D3DMETHOD_GETCLIPPLANE					:= 56
	static D3DMETHOD_SETRENDERSTATE					:= 57
	static D3DMETHOD_GETRENDERSTATE					:= 58
	static D3DMETHOD_CREATESTATEBLOCK				:= 59
	static D3DMETHOD_BEGINSTATEBLOCK				:= 60
	static D3DMETHOD_ENDSTATEBLOCK					:= 61
	static D3DMETHOD_SETCLIPSTATUS					:= 62
	static D3DMETHOD_GETCLIPSTATUS					:= 63
	static D3DMETHOD_GETTEXTURE						:= 64
	static D3DMETHOD_SETTEXTURE						:= 65
	static D3DMETHOD_GETTEXTURESTAGESTATE			:= 66
	static D3DMETHOD_SETTEXTURESTAGESTATE			:= 67
	static D3DMETHOD_GETSAMPLERSTATE				:= 68
	static D3DMETHOD_SETSAMPLERSTATE				:= 69
	static D3DMETHOD_VALIDATEDEVICE					:= 70
	static D3DMETHOD_SETPALETTEENTRIES				:= 71
	static D3DMETHOD_GETPALETTEENTRIES				:= 72
	static D3DMETHOD_SETCURRENTTEXTUREPALETTE		:= 73
	static D3DMETHOD_GETCURRENTTEXTUREPALETTE		:= 74
	static D3DMETHOD_SETSCISSORRECT					:= 75
	static D3DMETHOD_GETSCISSORRECT					:= 76
	static D3DMETHOD_SETSOFTWAREVERTEXPROCESSING	:= 77
	static D3DMETHOD_GETSOFTWAREVERTEXPROCESSING	:= 78
	static D3DMETHOD_SETNPATCHMODE					:= 79
	static D3DMETHOD_GETNPATCHMODE					:= 80
	static D3DMETHOD_DRAWPRIMITIVE					:= 81
	static D3DMETHOD_DRAWINDEXEDPRIMITIVE			:= 82
	static D3DMETHOD_DRAWPRIMITIVEUP				:= 83
	static D3DMETHOD_DRAWINDEXEDPRIMITIVEUP			:= 84
	static D3DMETHOD_PROCESSVERTICES				:= 85
	static D3DMETHOD_CREATEVERTEXDECLARATION		:= 86
	static D3DMETHOD_SETVERTEXDECLARATION			:= 87
	static D3DMETHOD_GETVERTEXDECLARATION			:= 88
	static D3DMETHOD_SETFVF							:= 89
	static D3DMETHOD_GETFVF							:= 90
	static D3DMETHOD_CREATEVERTEXSHADER				:= 91
	static D3DMETHOD_SETVERTEXSHADER				:= 92
	static D3DMETHOD_GETVERTEXSHADER				:= 93
	static D3DMETHOD_SETVERTEXSHADERCONSTANTF		:= 94
	static D3DMETHOD_GETVERTEXSHADERCONSTANTF		:= 95
	static D3DMETHOD_SETVERTEXSHADERCONSTANTI		:= 96
	static D3DMETHOD_GETVERTEXSHADERCONSTANTI		:= 97
	static D3DMETHOD_SETVERTEXSHADERCONSTANTB		:= 98
	static D3DMETHOD_GETVERTEXSHADERCONSTANTB		:= 99
	static D3DMETHOD_SETSTREAMSOURCE				:= 100
	static D3DMETHOD_GETSTREAMSOURCE				:= 101
	static D3DMETHOD_SETSTREAMSOURCEFREQ			:= 102
	static D3DMETHOD_GETSTREAMSOURCEFREQ			:= 103
	static D3DMETHOD_SETINDICES						:= 104
	static D3DMETHOD_GETINDICES						:= 105
	static D3DMETHOD_CREATEPIXELSHADER				:= 106
	static D3DMETHOD_SETPIXELSHADER					:= 107
	static D3DMETHOD_GETPIXELSHADER					:= 108
	static D3DMETHOD_SETPIXELSHADERCONSTANTF		:= 109
	static D3DMETHOD_GETPIXELSHADERCONSTANTF		:= 110
	static D3DMETHOD_SETPIXELSHADERCONSTANTI		:= 111
	static D3DMETHOD_GETPIXELSHADERCONSTANTI		:= 112
	static D3DMETHOD_SETPIXELSHADERCONSTANTB		:= 113
	static D3DMETHOD_GETPIXELSHADERCONSTANTB		:= 114
	static D3DMETHOD_DRAWRECTPATCH					:= 115
	static D3DMETHOD_DRAWTRIPATCH					:= 116
	static D3DMETHOD_DELETEPATCH					:= 117
	static D3DMETHOD_CREATEQUERY					:= 118

	; RakClientInterfaceFunctionsEnum
	static RCI_CONNECT								:= 0
	static RCI_DISCONNECT							:= 1
	static RCI_INITIALIZESECURITY					:= 2
	static RCI_SETPASSWORD							:= 3
	static RCI_HASPASSWORD							:= 4
	static RCI_SEND									:= 5
	static RCI_SENDBITSTREAM						:= 6
	static RCI_RECEIVE								:= 7
	static RCI_DEALLOCATEPACKET						:= 8
	static RCI_PINGSERVER							:= 9
	static RCI_PINGSERVEREX							:= 10
	static RCI_GETAVERAGEPING						:= 11
	static RCI_GETLASTPING							:= 12
	static RCI_GETLOWESTPING						:= 13
	static RCI_GETPLAYERPING						:= 14
	static RCI_STARTOCCASIONALPING					:= 15
	static RCI_STOPOCCASIONALPING					:= 16
	static RCI_ISCONNECTED							:= 17
	static RCI_GETSYNCHRONIZEDRANDOMINTEGER			:= 18
	static RCI_GENERATECOMPRESSIONLAYER				:= 19
	static RCI_DELETECOMPRESSIONLAYER				:= 20
	static RCI_REGISTERASREMOTEPROCEDURECALL		:= 21
	static RCI_REGISTERCLASSMEMBERRPC				:= 22
	static RCI_UNREGISTERASREMOTEPROCEDURECALL		:= 23
	static RCI_RPC									:= 24
	static RCI_RPCBITSTREAM							:= 25
	static RCI_RPCEX								:= 26
	static RCI_SETTRACKFREQUENCYTABLE				:= 27
	static RCI_GETSENDFREQUENCYTABLE				:= 28
	static RCI_GETCOMPRESSIONRATIO					:= 29
	static RCI_GETDECOMPRESSIONRATIO				:= 30
	static RCI_ATTACHPLUGIN							:= 31
	static RCI_DETACHPLUGIN							:= 32
	static RCI_GETSTATICSERVERDATA					:= 33
	static RCI_SETSTATICSERVERDATA					:= 34
	static RCI_GETSTATICCLIENTDATA					:= 35
	static RCI_SETSTATICCLIENTDATA					:= 36
	static RCI_SENDSTATICCLIENTDATATOSERVER			:= 37
	static RCI_GETSERVERID							:= 38
	static RCI_GETPLAYERID							:= 39
	static RCI_GETINTERNALID						:= 40
	static RCI_PLAYERIDTODOTTEDIP					:= 41
	static RCI_PUSHBACKPACKET						:= 42
	static RCI_SETROUTERINTERFACE					:= 43
	static RCI_REMOVEROUTERINTERFACE				:= 44
	static RCI_SETTIMEOUTTIME						:= 45
	static RCI_SETMTUSIZE							:= 46
	static RCI_GETMTUSIZE							:= 47
	static RCI_ALLOWCONNECTIONRESPONSEIPMIGRATION	:= 48
	static RCI_ADVERTISESYSTEM						:= 49
	static RCI_GETSTATISTICS						:= 50
	static RCI_APPLYNETWORKSIMULATOR				:= 51
	static RCI_ISNETWORKSIMULATORACTIVE				:= 52
	static RCI_GETPLAYERINDEX						:= 53

	; RPCEnumeration
	static RPC_ClickPlayer 							:= 23
	static RPC_ClientJoin 							:= 25
	static RPC_EnterVehicle 						:= 26
	static RPC_EnterEditObject 						:= 27
	static RPC_ScriptCash 							:= 31
	static RPC_ServerCommand 						:= 50
	static RPC_Spawn 								:= 52
	static RPC_Death 								:= 53
	static RPC_NPCJoin 								:= 54
	static RPC_DialogResponse 						:= 62
	static RPC_ClickTextDraw 						:= 83
	static RPC_ScmEvent 							:= 96
	static RPC_WeaponPickupDestroy 					:= 97
	static RPC_Chat 								:= 101
	static RPC_SrvNetStats 							:= 102
	static RPC_ClientCheck 							:= 103
	static RPC_DamageVehicle 						:= 106
	static RPC_GiveTakeDamage 						:= 115
	static RPC_EditAttachedObject 					:= 116
	static RPC_EditObject 							:= 117
	static RPC_SetInteriorId 						:= 118
	static RPC_MapMarker 							:= 119
	static RPC_RequestClass 						:= 128
	static RPC_RequestSpawn 						:= 129
	static RPC_PickedUpPickup 						:= 131
	static RPC_MenuSelect 							:= 132
	static RPC_VehicleDestroyed 					:= 136
	static RPC_MenuQuit 							:= 140
	static RPC_ExitVehicle 							:= 154
	static RPC_UpdateScoresPingsIPs 				:= 155

	; ScriptRPCEnumeration
	static RPC_ScrSetPlayerName 					:= 11
	static RPC_ScrSetPlayerPos 						:= 12
	static RPC_ScrSetPlayerPosFindZ 				:= 13
	static RPC_ScrSetPlayerHealth 					:= 14
	static RPC_ScrTogglePlayerControllable 			:= 15
	static RPC_ScrPlaySound 						:= 16
	static RPC_ScrSetPlayerWorldBounds 				:= 17
	static RPC_ScrGivePlayerMoney 					:= 18
	static RPC_ScrSetPlayerFacingAngle 				:= 19
	static RPC_ScrResetPlayerMoney 					:= 20
	static RPC_ScrResetPlayerWeapons 				:= 21
	static RPC_ScrGivePlayerWeapon 					:= 22
	static RPC_ScrSetVehicleParamsEx 				:= 24
	static RPC_ScrCancelEdit 						:= 28
	static RPC_ScrSetPlayerTime 					:= 29
	static RPC_ScrToggleClock 						:= 30
	static RPC_ScrWorldPlayerAdd 					:= 32
	static RPC_ScrSetPlayerShopName 				:= 33
	static RPC_ScrSetPlayerSkillLevel 				:= 34
	static RPC_ScrSetPlayerDrunkLevel 				:= 35
	static RPC_ScrCreate3DTextLabel 				:= 36
	static RPC_ScrDisableCheckpoint 				:= 37
	static RPC_ScrSetRaceCheckpoint 				:= 38
	static RPC_ScrDisableRaceCheckpoint 			:= 39
	static RPC_ScrGameModeRestart 					:= 40
	static RPC_ScrPlayAudioStream 					:= 41
	static RPC_ScrStopAudioStream 					:= 42
	static RPC_ScrRemoveBuildingForPlayer 			:= 43
	static RPC_ScrCreateObject 						:= 44
	static RPC_ScrSetObjectPos 						:= 45
	static RPC_ScrSetObjectRot 						:= 46
	static RPC_ScrDestroyObject 					:= 47
	static RPC_ScrDeathMessage 						:= 55
	static RPC_ScrSetPlayerMapIcon 					:= 56
	static RPC_ScrRemoveVehicleComponent 			:= 57
	static RPC_ScrUpdate3DTextLabel 				:= 58
	static RPC_ScrChatBubble 						:= 59
	static RPC_ScrSomeupdate 						:= 60
	static RPC_ScrShowDialog 						:= 61
	static RPC_ScrDestroyPickup 					:= 63
	static RPC_ScrLinkVehicleToInterior 			:= 65
	static RPC_ScrSetPlayerArmour 					:= 66
	static RPC_ScrSetPlayerArmedWeapon 				:= 67
	static RPC_ScrSetSpawnInfo 						:= 68
	static RPC_ScrSetPlayerTeam 					:= 69
	static RPC_ScrPutPlayerInVehicle 				:= 70
	static RPC_ScrRemovePlayerFromVehicle 			:= 71
	static RPC_ScrSetPlayerColor 					:= 72
	static RPC_ScrDisplayGameText 					:= 73
	static RPC_ScrForceClassSelection 				:= 74
	static RPC_ScrAttachObjectToPlayer 				:= 75
	static RPC_ScrInitMenu 							:= 76
	static RPC_ScrShowMenu 							:= 77
	static RPC_ScrHideMenu 							:= 78
	static RPC_ScrCreateExplosion 					:= 79
	static RPC_ScrShowPlayerNameTagForPlayer 		:= 80
	static RPC_ScrAttachCameraToObject 				:= 81
	static RPC_ScrInterpolateCamera 				:= 82
	static RPC_ScrSetObjectMaterial 				:= 84
	static RPC_ScrGangZoneStopFlash 				:= 85
	static RPC_ScrApplyAnimation 					:= 86
	static RPC_ScrClearAnimations 					:= 87
	static RPC_ScrSetPlayerSpecialAction 			:= 88
	static RPC_ScrSetPlayerFightingStyle 			:= 89
	static RPC_ScrSetPlayerVelocity 				:= 90
	static RPC_ScrSetVehicleVelocity 				:= 91
	static RPC_ScrClientMessage 					:= 93
	static RPC_ScrSetWorldTime 						:= 94
	static RPC_ScrCreatePickup 						:= 95
	static RPC_ScrMoveObject 						:= 99
	static RPC_ScrEnableStuntBonusForPlayer 		:= 104
	static RPC_ScrTextDrawSetString 				:= 105
	static RPC_ScrSetCheckpoint 					:= 107
	static RPC_ScrGangZoneCreate 					:= 108
	static RPC_ScrPlayCrimeReport 					:= 112
	static RPC_ScrSetPlayerAttachedObject 			:= 113
	static RPC_ScrGangZoneDestroy 					:= 120
	static RPC_ScrGangZoneFlash 					:= 121
	static RPC_ScrStopObject 						:= 122
	static RPC_ScrSetNumberPlate 					:= 123
	static RPC_ScrTogglePlayerSpectating 			:= 124
	static RPC_ScrPlayerSpectatePlayer 				:= 126
	static RPC_ScrPlayerSpectateVehicle 			:= 127
	static RPC_ScrSetPlayerWantedLevel 				:= 133
	static RPC_ScrShowTextDraw 						:= 134
	static RPC_ScrTextDrawHideForPlayer 			:= 135
	static RPC_ScrServerJoin 						:= 137
	static RPC_ScrServerQuit 						:= 138
	static RPC_ScrInitGame 							:= 139
	static RPC_ScrRemovePlayerMapIcon 				:= 144
	static RPC_ScrSetPlayerAmmo 					:= 145
	static RPC_ScrSetGravity 						:= 146
	static RPC_ScrSetVehicleHealth 					:= 147
	static RPC_ScrAttachTrailerToVehicle 			:= 148
	static RPC_ScrDetachTrailerFromVehicle 			:= 149
	static RPC_ScrSetWeather 						:= 152
	static RPC_ScrSetPlayerSkin 					:= 153
	static RPC_ScrSetPlayerInterior 				:= 156
	static RPC_ScrSetPlayerCameraPos 				:= 157
	static RPC_ScrSetPlayerCameraLookAt 			:= 158
	static RPC_ScrSetVehiclePos 					:= 159
	static RPC_ScrSetVehicleZAngle 					:= 160
	static RPC_ScrSetVehicleParamsForPlayer 		:= 161
	static RPC_ScrSetCameraBehindPlayer 			:= 162
	static RPC_ScrWorldPlayerRemove 				:= 163
	static RPC_ScrWorldVehicleAdd 					:= 164
	static RPC_ScrWorldVehicleRemove 				:= 165

	; PacketEnumeration
	static ID_INTERNAL_PING 						:= 6
	static ID_PING									:= 7
	static ID_PING_OPEN_CONNECTIONS					:= 8
	static ID_CONNECTED_PONG						:= 9
	static ID_REQUEST_STATIC_DATA					:= 10
	static ID_CONNECTION_REQUEST					:= 11
	static ID_AUTH_KEY								:= 12
	static ID_BROADCAST_PINGS						:= 14
	static ID_SECURED_CONNECTION_RESPONSE			:= 15
	static ID_SECURED_CONNECTION_CONFIRMATION		:= 16
	static ID_RPC_MAPPING							:= 17
	static ID_SET_RANDOM_NUMBER_SEED				:= 19
	static ID_RPC									:= 20
	static ID_RPC_REPLY								:= 21
	static ID_DETECT_LOST_CONNECTIONS				:= 23
	static ID_OPEN_CONNECTION_REQUEST				:= 24
	static ID_OPEN_CONNECTION_REPLY					:= 25
	static ID_CONNECTION_COOKIE						:= 26
	static ID_RSA_PUBLIC_KEY_MISMATCH				:= 28
	static ID_CONNECTION_ATTEMPT_FAILED				:= 29
	static ID_NEW_INCOMING_CONNECTION				:= 30
	static ID_NO_FREE_INCOMING_CONNECTIONS			:= 31
	static ID_DISCONNECTION_NOTIFICATION			:= 32
	static ID_CONNECTION_LOST						:= 33
	static ID_CONNECTION_REQUEST_ACCEPTED			:= 34
	static ID_INITIALIZE_ENCRYPTION					:= 35
	static ID_CONNECTION_BANNED						:= 36
	static ID_INVALID_PASSWORD						:= 37
	static ID_MODIFIED_PACKET						:= 38
	static ID_PONG									:= 39
	static ID_TIMESTAMP								:= 40
	static ID_RECEIVED_STATIC_DATA					:= 41
	static ID_REMOTE_DISCONNECTION_NOTIFICATION		:= 42
	static ID_REMOTE_CONNECTION_LOST				:= 43
	static ID_REMOTE_NEW_INCOMING_CONNECTION		:= 44
	static ID_REMOTE_EXISTING_CONNECTION			:= 45
	static ID_REMOTE_STATIC_DATA					:= 46
	static ID_ADVERTISE_SYSTEM						:= 56

	static ID_VEHICLE_SYNC							:= 200
	static ID_RCON_COMMAND							:= 201
	static ID_RCON_RESPONCE							:= 202
	static ID_AIM_SYNC								:= 203
	static ID_WEAPONS_UPDATE						:= 204
	static ID_STATS_UPDATE							:= 205
	static ID_BULLET_SYNC							:= 206
	static ID_PLAYER_SYNC							:= 207
	static ID_MARKERS_SYNC							:= 208
	static ID_UNOCCUPIED_SYNC						:= 209
	static ID_TRAILER_SYNC							:= 210
	static ID_PASSENGER_SYNC						:= 211
	static ID_SPECTATOR_SYNC						:= 212

	; PacketPriority
	static SYSTEM_PRIORITY							:= 0 ; internal Used by RakNet to send above-high priority messages.
	static HIGH_PRIORITY							:= 1 ; High priority messages are send before medium priority messages.
	static MEDIUM_PRIORITY							:= 2 ; Medium priority messages are send before low priority messages.
	static LOW_PRIORITY								:= 3 ; Low priority messages are only sent when no other messages are waiting.
	static NUMBER_OF_PRIORITIES						:= 4

	; PacketReliability
	static UNRELIABLE								:= 6 ; Same as regular UDP, except that it will also discard duplicate datagrams.  RakNet adds (6 to 17) + 21 bits of overhead, 16 of which is used to detect duplicate packets and 6 to 17 of which is used for message length.
	static UNRELIABLE_SEQUENCED						:= 7 ; Regular UDP with a sequence counter.  Out of order messages will be discarded.  This adds an additional 13 bits on top what is used for UNRELIABLE.
	static RELIABLE									:= 8 ; The message is sent reliably, but not necessarily in any order.  Same overhead as UNRELIABLE.
	static RELIABLE_ORDERED							:= 9 ; This message is reliable and will arrive in the order you sent it.  Messages will be delayed while waiting for out of order messages.  Same overhead as UNRELIABLE_SEQUENCED.
	static RELIABLE_SEQUENCED						:= 10 ; This message is reliable and will arrive in the sequence you sent it.  Out or order messages will be dropped.  Same overhead as UNRELIABLE_SEQUENCED.
		
	static DLL			:= "AHK-SAMPFUNCS-Module.sf"
		, hModule		:= 0
		, Funcs			:= {}
		, CallBackAddr	:= []
	
	__New() ; Constructor.
	{
		if (!this.hModule)
		{
			i := 0
			while (i < 3)
			{
				time_start := A_TickCount
				while ((A_TickCount - time_start) < 500)
				{
					this.hModule := GetModuleHandle(this.DLL)
					if (this.hModule != 0)
						goto SuccessLoad
				}
				URLDownloadToFile, https://raw.githubusercontent.com/RinatNamazov/AHK-SAMPFUNCS-API/master/AHK-SAMPFUNCS-Module.sf, % A_ScriptDir "\SAMPFUNCS\" this.DLL
				LoadLibrary(A_ScriptDir "\SAMPFUNCS\" this.DLL)
				i++
			}
			if (i == 3)
				return false
		}
	SuccessLoad:
		this.Funcs.ModuleIsInit						:= GetProcAddress(this.hModule, "ModuleIsInit")
	; SF BEGIN.
		this.Funcs.Log								:= GetProcAddress(this.hModule, "Log")
		this.Funcs.LogFile							:= GetProcAddress(this.hModule, "LogFile")
		this.Funcs.LogConsole						:= GetProcAddress(this.hModule, "LogConsole")
		this.Funcs.getSFVersion						:= GetProcAddress(this.hModule, "getSFVersion")
		this.Funcs.getAPIVersion					:= GetProcAddress(this.hModule, "getAPIVersion")
		this.Funcs.registerChatCommand				:= GetProcAddress(this.hModule, "registerChatCommand")
		this.Funcs.registerConsoleCommand			:= GetProcAddress(this.hModule, "registerConsoleCommand")
		this.Funcs.unregisterConsoleCommand			:= GetProcAddress(this.hModule, "unregisterConsoleCommand")
		this.Funcs.execConsoleCommand				:= GetProcAddress(this.hModule, "execConsoleCommand")
		this.Funcs.isConsoleOpened					:= GetProcAddress(this.hModule, "isConsoleOpened")
		this.Funcs.isPluginLoaded					:= GetProcAddress(this.hModule, "isPluginLoaded")
		this.Funcs.loadPlugin						:= GetProcAddress(this.hModule, "loadPlugin")
		this.Funcs.unloadPlugin						:= GetProcAddress(this.hModule, "unloadPlugin")
		this.Funcs.setConsoleCommandDescription		:= GetProcAddress(this.hModule, "setConsoleCommandDescription")
	; SF END.
		
	; SFCLEO BEGIN.
		this.Funcs.registerNewOpcode				:= GetProcAddress(this.hModule, "registerNewOpcode")
		this.Funcs.callOpcode						:= GetProcAddress(this.hModule, "callOpcode")
		this.Funcs.callOpcodeInThread				:= GetProcAddress(this.hModule, "callOpcodeInThread")
		this.Funcs.SetLocalVar						:= GetProcAddress(this.hModule, "SetLocalVar")
		this.Funcs.SetLocalVarAsFloat				:= GetProcAddress(this.hModule, "SetLocalVarAsFloat")
		this.Funcs.GetLocalVar						:= GetProcAddress(this.hModule, "GetLocalVar")
		this.Funcs.GetCondResult					:= GetProcAddress(this.hModule, "GetCondResult")
		this.Funcs.SetGlobalVar						:= GetProcAddress(this.hModule, "SetGlobalVar")
		this.Funcs.GetGlobalVar						:= GetProcAddress(this.hModule, "GetGlobalVar")
		this.Funcs.executeThreadTillReturn			:= GetProcAddress(this.hModule, "executeThreadTillReturn")
		this.Funcs.executeThreadOnce				:= GetProcAddress(this.hModule, "executeThreadOnce")
	; SFCLEO END.
	
	; SFGAME BEGIN.
		this.Funcs.registerWndProcCallback			:= GetProcAddress(this.hModule, "registerWndProcCallback")
		this.Funcs.registerGameDestructorCallback	:= GetProcAddress(this.hModule, "registerGameDestructorCallback")
		this.Funcs.isKeyPressed						:= GetProcAddress(this.hModule, "isKeyPressed")
		this.Funcs.isKeyDown						:= GetProcAddress(this.hModule, "isKeyDown")
		this.Funcs.isGTAMenuActive					:= GetProcAddress(this.hModule, "isGTAMenuActive")
		this.Funcs.isGTAForeground					:= GetProcAddress(this.hModule, "isGTAForeground")
		this.Funcs.convert3DCoordsToScreen			:= GetProcAddress(this.hModule, "convert3DCoordsToScreen")
		this.Funcs.convertScreenCoordsTo3D			:= GetProcAddress(this.hModule, "convertScreenCoordsTo3D")
		this.Funcs.emulateGTAKey					:= GetProcAddress(this.hModule, "emulateGTAKey")
		this.Funcs.getScreenResolution				:= GetProcAddress(this.hModule, "getScreenResolution")
		this.Funcs.getCursorPos						:= GetProcAddress(this.hModule, "getCursorPos")
		this.Funcs.convertWindowCoordsToGame		:= GetProcAddress(this.hModule, "convertWindowCoordsToGame")
		this.Funcs.convertGameCoordsToWindow		:= GetProcAddress(this.hModule, "convertGameCoordsToWindow")
		this.Funcs.createHook						:= GetProcAddress(this.hModule, "createHook")
		this.Funcs.actorInfoGet						:= GetProcAddress(this.hModule, "actorInfoGet")
		this.Funcs.vehicleInfoGet					:= GetProcAddress(this.hModule, "vehicleInfoGet")
		this.Funcs.getActorPoolSize					:= GetProcAddress(this.hModule, "getActorPoolSize")
		this.Funcs.getVehiclePoolSize				:= GetProcAddress(this.hModule, "getVehiclePoolSize")
		this.Funcs.getCurrentState					:= GetProcAddress(this.hModule, "getCurrentState")
		this.Funcs.getOrthMatrix					:= GetProcAddress(this.hModule, "getOrthMatrix")
		this.Funcs.makeOrthMatrix					:= GetProcAddress(this.hModule, "makeOrthMatrix")
	; SFGAME END.
	
	; SFRAKNET BEGIN.
		this.Funcs.getRPCName						:= GetProcAddress(this.hModule, "getRPCName")
		this.Funcs.getPacketName					:= GetProcAddress(this.hModule, "getPacketName")
		this.Funcs.getRakClient						:= GetProcAddress(this.hModule, "getRakClient")
		this.Funcs.registerRakNetCallback			:= GetProcAddress(this.hModule, "registerRakNetCallback")
	; SFRAKNET END.
	
	; BITSTREAM BEGIN
		this.Funcs.BitStreamInit					:= GetProcAddress(this.hModule, "BitStreamInit")
		this.Funcs.GetPacketId						:= GetProcAddress(this.hModule, "GetPacketId")
		this.Funcs.GetPacketPriority				:= GetProcAddress(this.hModule, "GetPacketPriority")
		this.Funcs.GetPacketReliability				:= GetProcAddress(this.hModule, "GetPacketReliability")
		this.Funcs.GetPacketOrderingChannel			:= GetProcAddress(this.hModule, "GetPacketOrderingChannel")
		this.Funcs.GetPacketShiftTimestamp			:= GetProcAddress(this.hModule, "GetPacketShiftTimestamp")
		this.Funcs.GetReadOffset					:= GetProcAddress(this.hModule, "GetReadOffset")
		this.Funcs.ResetReadPointer					:= GetProcAddress(this.hModule, "ResetReadPointer")
		this.Funcs.SetReadOffset					:= GetProcAddress(this.hModule, "SetReadOffset")
		this.Funcs.IgnoreBits						:= GetProcAddress(this.hModule, "IgnoreBits")
		this.Funcs.GetNumberOfBitsUsed				:= GetProcAddress(this.hModule, "GetNumberOfBitsUsed")
		this.Funcs.GetNumberOfBytesUsed				:= GetProcAddress(this.hModule, "GetNumberOfBytesUsed")
		this.Funcs.ReadByte							:= GetProcAddress(this.hModule, "ReadByte")
		this.Funcs.ReadChar							:= GetProcAddress(this.hModule, "ReadChar")
		this.Funcs.ReadDword						:= GetProcAddress(this.hModule, "ReadDword")
		this.Funcs.ReadFloat						:= GetProcAddress(this.hModule, "ReadFloat")
		this.Funcs.ReadInt							:= GetProcAddress(this.hModule, "ReadInt")
		this.Funcs.ReadShort						:= GetProcAddress(this.hModule, "ReadShort")
		this.Funcs.ResetWritePointer				:= GetProcAddress(this.hModule, "ResetWritePointer")
		this.Funcs.GetWriteOffset					:= GetProcAddress(this.hModule, "GetWriteOffset")
		this.Funcs.SetWriteOffset					:= GetProcAddress(this.hModule, "SetWriteOffset")
		this.Funcs.WriteByte						:= GetProcAddress(this.hModule, "WriteByte")
		this.Funcs.WriteChar						:= GetProcAddress(this.hModule, "WriteChar")
		this.Funcs.WriteDword						:= GetProcAddress(this.hModule, "WriteDword")
		this.Funcs.WriteFloat						:= GetProcAddress(this.hModule, "WriteFloat")
		this.Funcs.WriteInt							:= GetProcAddress(this.hModule, "WriteInt")
		this.Funcs.WriteShort						:= GetProcAddress(this.hModule, "WriteShort")
	; BITSTREAM END
	
	; SFSAMP BEGIN.
		this.Funcs.getSAMPAddr						:= GetProcAddress(this.hModule, "getSAMPAddr")
		this.Funcs.IsInitialized					:= GetProcAddress(this.hModule, "IsInitialized")
		this.Funcs.SendChat							:= GetProcAddress(this.hModule, "SendChat")
		this.Funcs.registerChatCommand				:= GetProcAddress(this.hModule, "registerChatCommand")
		this.Funcs.AddChatMessage					:= GetProcAddress(this.hModule, "AddChatMessage")
		this.Funcs.ShowDialog						:= GetProcAddress(this.hModule, "ShowDialog")
		this.Funcs.registerDialogCallback			:= GetProcAddress(this.hModule, "registerDialogCallback")
		this.Funcs.getLocalPlayerNickName			:= GetProcAddress(this.hModule, "getLocalPlayerNickName")
		this.Funcs.getLocalPlayerId					:= GetProcAddress(this.hModule, "getLocalPlayerId")
		this.Funcs.GetPlayerName					:= GetProcAddress(this.hModule, "GetPlayerName")
		this.Funcs.GetPlayerColor					:= GetProcAddress(this.hModule, "GetPlayerColor")
		this.Funcs.IsPlayerDefined					:= GetProcAddress(this.hModule, "IsPlayerDefined")
		this.Funcs.isDialogOpen						:= GetProcAddress(this.hModule, "isDialogOpen")
		this.Funcs.SetDialogOpenStatus				:= GetProcAddress(this.hModule, "SetDialogOpenStatus")
	; SFSAMP END.
	
		return this
	}
	
	__Delete() ; Destructor.
	{
		for k, v in this.CallBackAddr
			DllCall("Kernel32.dll\GlobalFree", "UInt", v) ; Очистка пам¤ти.
	}
	
	ModuleIsInit()
	{
		return DllCall(this.Funcs.ModuleIsInit)
	}
	
; SF BEGIN.
	Log(pText)
	{
		return DllCall(this.Funcs.Log, "Str", pText)
	}
	
	LogFile(pText)
	{
		return DllCall(this.Funcs.LogFile, "Str", pText)
	}
	
	LogConsole(pText)
	{
		return DllCall(this.Funcs.LogConsole, "Str", pText)
	}
	
	getSFVersion()
	{
		return DllCall(this.Funcs.getSFVersion, "UInt")
	}
	
	getAPIVersion()
	{
		return DllCall(this.Funcs.getAPIVersion, "UInt")
	}
	
	registerConsoleCommand(command, function)
	{
		if (func_addr := RegisterCallback(function))
		{
			this.CallBackAddr[command] := func_addr
			return DllCall(this.Funcs.registerConsoleCommand, "Str", command, "UInt", func_addr)
		}
		return false	
	}
	
	unregisterConsoleCommand(command)
	{
		if (this.CallBackAddr[command] == "")
			return false
		DllCall("Kernel32.dll\GlobalFree", "UInt", this.CallBackAddr[command])
		this.CallBackAddr.Delete(command)
		return DllCall(this.Funcs.unregisterConsoleCommand, "Str", command)
	}
	
	execConsoleCommand(command)
	{
		return DllCall(this.Funcs.execConsoleCommand, "Str", command)
	}
	
	isConsoleOpened()
	{
		return DllCall(this.Funcs.isConsoleOpened)
	}
	
	isPluginLoaded(pluginName)
	{
		return DllCall(this.Funcs.isPluginLoaded, "Str", pluginName)
	}
	
	loadPlugin(pluginName)
	{
		return DllCall(this.Funcs.loadPlugin, "Str", pluginName)
	}
	
	unloadPlugin(pluginName)
	{
		return DllCall(this.Funcs.unloadPlugin, "Str", pluginName)
	}
	
	setConsoleCommandDescription(command, description)
	{
		return DllCall(this.Funcs.setConsoleCommandDescription, "Str", command, "Str", description)
	}
; SF END.
	
; SFCLEO BEGIN.
	registerNewOpcode(opcode, function)
	{
		if (this.CallBackAddr[opcode] != "")
			return false
		if (func_addr := RegisterCallback(function))
		{
			this.CallBackAddr[opcode] := func_addr
			return DllCall(this.Funcs.registerNewOpcode, "UInt", opcode, "UInt", func_addr)
		}
		return false	
	}
	
	callOpcode(fmt, thread := false)
	{
		if (!thread)
			return DllCall(this.Funcs.callOpcode, "Str", fmt)
		; TODO:
	;	return DllCall(this.Funcs.callOpcodeInThread, "???", thread, "Str", fmt)
	}
	
	SetLocalVar(idx, value, isFloat := false)
	{
		if (isFloat)
			return DllCall(this.Funcs.SetLocalVarAsFloat, "UShort", idx, "Float", value)
		return DllCall(this.Funcs.SetLocalVar, "UShort", idx, "UInt", value)
	}

	GetLocalVar(idx)
	{
		return DllCall(this.Funcs.GetLocalVar, "UShort", idx, "UInt")
	}
	
	GetCondResult()
	{
		return DllCall(this.Funcs.GetCondResult, "UInt")
	}
	
	SetGlobalVar(idx, value)
	{
		return DllCall(this.Funcs.SetGlobalVar, "UShort", idx, "UInt", value)
	}
	
	GetGlobalVar(idx)
	{
		return DllCall(this.Funcs.GetGlobalVar, "UShort", idx, "UInt")
	}
	
	executeThreadTillReturn(thread)
	{
		; TODO:
		return DllCall(this.Funcs.executeThreadTillReturn, "Str", thread)
	}
	
	executeThreadOnce(thread)
	{
		; TODO:
		return DllCall(this.Funcs.executeThreadOnce, "Str", thread)
	}
; SFCLEO END.

; SFGAME BEGIN.
	registerWndProcCallback(eCallbackPriority, function)
	{
		if (eCallbackPriority < 0 || eCallbackPriority > 3)
			return false
		if (func_addr := RegisterCallback(function))
		{
			this.CallBackAddr.Push(func_addr)
			return DllCall(this.Funcs.registerWndProcCallback, "Int", eCallbackPriority, "UInt", func_addr)
		}
		return false
	}

	registerGameDestructorCallback(function)
	{
		if (func_addr := RegisterCallback(function))
		{
			this.CallBackAddr.Push(func_addr)
			return DllCall(this.Funcs.registerGameDestructorCallback, "UInt", func_addr)
		}
		return false
	}

	isKeyPressed(iKey)
	{
		return DllCall(this.Funcs.isKeyPressed, "UChar", iKey)
	}

	isKeyDown(iKey)
	{
		return DllCall(this.Funcs.isKeyDown, "UChar", iKey)
	}

	isGTAMenuActive()
	{
		return DllCall(this.Funcs.isGTAMenuActive)
	}

	isGTAForeground()
	{
		return DllCall(this.Funcs.isGTAForeground)
	}

	convert3DCoordsToScreen(fX, fY, fZ, ByRef fScreenX, ByRef fScreenY)
	{
		VarSetCapacity(fScreenX, 4, 0), VarSetCapacity(fScreenY, 4, 0)
		ret := DllCall(this.Funcs.convert3DCoordsToScreen, "float", fX, "float", fY, "float", fZ, "float", fScreenX, "float", fScreenY)
		fScreenX := NumGet(fScreenX, "float")
		fScreenY := NumGet(fScreenY, "float")
		return ret
	}

	convertScreenCoordsTo3D(fScreenX, fScreenY, fDepth, ByRef fX, ByRef fY, ByRef fZ)
	{
		VarSetCapacity(fX, 4, 0), VarSetCapacity(fY, 4, 0), VarSetCapacity(fZ, 4, 0)
		ret := DllCall(this.Funcs.convertScreenCoordsTo3D, "float", fScreenX, "float", fScreenY, "float", fDepth, "float", fX, "float", fY, "float", fZ)
		fX := NumGet(fX, "float")
		fY := NumGet(fY, "float")
		fZ := NumGet(fZ, "float")
		return ret
	}

	emulateGTAKey(iKey, iState)
	{
		return DllCall(this.Funcs.emulateGTAKey, "Int", iKey, "Int", iState)
	}

	getScreenResolution(ByRef iX, ByRef iY)
	{
		VarSetCapacity(iX, 4, 0), VarSetCapacity(iY, 4, 0)
		ret := DllCall(this.Funcs.getScreenResolution, "Int", iX, "Int", iY)
		iX := NumGet(iX, "Int")
		iY := NumGet(iY, "Int")
		return ret
	}

	getCursorPos()
	{
		; struct {LONG  x; LONG y;}
		VarSetCapacity(POINT, 8, 0)
		ret := DllCall(this.Funcs.getCursorPos)
		return { x: NumGet(&ret, "Int"), y: NumGet(&ret, 4, "Int") }
	}

	convertWindowCoordsToGame(fWX, fWY, ByRef fGX, ByRef fGY)
	{
		VarSetCapacity(fGX, 4, 0), VarSetCapacity(fGY, 4, 0)
		ret := DllCall(this.Funcs.convertWindowCoordsToGame, "float" fWX, "float", fWY, "float", fGX, "float", fGY)
		fGX := NumGet(fGX, "float")
		fGY := NumGet(fGY, "float")
		return ret
	}

	convertGameCoordsToWindow(fGX, fGY, ByRef fWX, ByRef fWY)
	{
		VarSetCapacity(fWX, 4, 0), VarSetCapacity(fWY, 4, 0)
		ret := DllCall(this.Funcs.convertGameCoordsToWindow, "float" fGX, "float", fGY, "float", fWX, "float", fWY)
		fWX := NumGet(fWX, "float")
		fWY := NumGet(fWY, "float")
		return ret
	}

	createHook(address, destination, type := 0, len := 0)
	{
		return DllCall(this.Funcs.createHook, "Ptr", address, "Ptr", destination, "Int", type, "UInt", len)
	}

	actorInfoGet(id, flags)
	{
		; TODO:
		return DllCall(this.Funcs.actorInfoGet, "Int", id, "Int", flags, "Str")
	}

	vehicleInfoGet(id, flags)
	{
		; TODO:
		return DllCall(this.Funcs.vehicleInfoGet, "Int", id, "Int", flags, "Str")
	}

	getActorPoolSize()
	{
		return DllCall(this.Funcs.getActorPoolSize, "UInt")
	}

	getVehiclePoolSize()
	{
		return DllCall(this.Funcs.getVehiclePoolSize, "UInt")
	}

	getCurrentState()
	{
		return DllCall(this.Funcs.getCurrentState, "UInt")
	}

	getOrthMatrix(m00, m01, m02, m10, m11, m12, m20, m21, m22, ByRef fOutW, ByRef fOutX, ByRef fOutY, ByRef fOutZ)
	{
		VarSetCapacity(fOutW, 4, 0), VarSetCapacity(fOutX, 4, 0), VarSetCapacity(fOutY, 4, 0), VarSetCapacity(fOutZ, 4, 0)
		ret := DllCall(this.Funcs.getOrthMatrix, "float", m00, "float", m01, "float", m02, "float", m10, "float", m11, "float", m12
							, "float", m20, "float", m21, "float", m22, "float", fOutW, "float", fOutX, "float", fOutY, "float", fOutZ)
		fOutW := NumGet(fOutW, "float")
		fOutX := NumGet(fOutX, "float")
		fOutY := NumGet(fOutY, "float")
		fOutZ := NumGet(fOutZ, "float")
		return ret
	}

	makeOrthMatrix(fInW, fInX, fInY, fInZ, ByRef m00, ByRef m01, ByRef m02, ByRef m10, ByRef m11, ByRef m12, ByRef m20, ByRef m21, ByRef m22)
	{
		VarSetCapacity(m00, 4, 0), VarSetCapacity(m01, 4, 0), VarSetCapacity(m02, 4, 0), VarSetCapacity(m10, 4, 0), VarSetCapacity(m11, 4, 0), VarSetCapacity(m12, 4, 0), VarSetCapacity(m20, 4, 0)
		, VarSetCapacity(m21, 4, 0), VarSetCapacity(m22, 4, 0)
		ret := DllCall(this.Funcs.makeOrthMatrix, "float", fInW, "float", fInX, "float", fInY, "float", fInZ, "float", m00, "float", m01
									, "float", m02, "float", m10, "float", m11, "float", m12, "float", m20, "float", m21, "float", m22)
		m00 := NumGet(m00, "float")
		m01 := NumGet(m01, "float")
		m02 := NumGet(m02, "float")
		m10 := NumGet(m10, "float")
		m11 := NumGet(m11, "float")
		m12 := NumGet(m12, "float")
		m20 := NumGet(m20, "float")
		m21 := NumGet(m21, "float")
		m22 := NumGet(m22, "float")
		return ret
	}
; SFGAME END.

; SFRAKNET BEGIN.
	getRPCName(iRPCID)
	{
		return DllCall(this.Funcs.getRPCName, "Int", iRPCID)
	}
	
	getPacketName(iPacketID)
	{
		return DllCall(this.Funcs.getPacketName, "Int", iPacketID)
	}
	
	getRakClient()
	{
		; TODO:
		return DllCall(this.Funcs.getRakClient, "Str")
	}

	RegisterRakNetCallback(eCallbackType, function)
	{
		if (eCallbackType < 0 || eCallbackType > 3)
			return false
		if (func_addr := RegisterCallback(function))
		{
			this.CallBackAddr.Push(func_addr)
			DllCall(this.Funcs.RegisterRakNetCallback, "Int", eCallbackType, "UInt", func_addr)
		}
		return false
	}
; SFRAKNET END.

; BITSTREAM BEGIN.
	BitStream(addr, method := "", ByRef params := "", len := "")
	{
		isErrorType := true
		static types := { Char: "Str", Dword: "UInt", Byte: "UChar", int: "Int", Short: "Short", Float: "Float" }
		if (method == "")
		{
			DllCall(this.Funcs.BitStreamInit, "UInt", addr)
			packetId		:= DllCall(this.Funcs.GetPacketId)
			priority		:= DllCall(this.Funcs.GetPacketPriority)
			reliability		:= DllCall(this.Funcs.GetPacketReliability)
			orderingChannel	:= DllCall(this.Funcs.GetPacketOrderingChannel, "Str")
			shiftTimestamp	:= DllCall(this.Funcs.GetPacketShiftTimestamp, "Str")
			return { base: { __Call: ObjBindMethod(this, "BitStream") }, packetId: packetId, priority: priority, reliability: reliability, orderingChannel: orderingChannel, shiftTimestamp: shiftTimestamp }
		}
		else if (method == "GetNumberOfBitsUsed")
			return DllCall(this.Funcs.GetNumberOfBitsUsed)
		else if (method == "GetNumberOfBytesUsed")
			return DllCall(this.Funcs.GetNumberOfBytesUsed)
		else if (method == "ResetReadPointer")
			return DllCall(this.Funcs.ResetReadPointer)
		else if (method == "IgnoreBits")
			return DllCall(this.Funcs.IgnoreBits, "Int", params)
		else if (method == "SetReadOffset")
			return DllCall(this.Funcs.SetReadOffset, "Int", params)
		else if (method == "Read")
		{
			ReadType := { Dword: this.Funcs.ReadDword, Byte: this.Funcs.ReadByte, int: this.Funcs.ReadInt, Short: this.Funcs.ReadShort, Float: this.Funcs.ReadFloat }
			gosub CheckType
			if (isErrorType)
				return false
			params := type == "Str" ? DllCall(this.Funcs.ReadChar, "Int", len, "Str") : DllCall(ReadType[len], type)
			return true
		}
		else if (method == "GetWriteOffset")
			return DllCall(this.Funcs.GetWriteOffset)
		else if (method == "SetWriteOffset")
			return DllCall(this.Funcs.SetWriteOffset, "Int", params)
		else if (method == "ResetWritePointer")
			return DllCall(this.Funcs.ResetWritePointer)
		else if (method == "Write")
		{
			WriteType := { Dword: this.Funcs.WriteDword, Byte: this.Funcs.WriteByte, int: this.Funcs.WriteInt, Short: this.Funcs.WriteShort, Float: this.Funcs.WriteFloat }
			gosub CheckType
			if (isErrorType)
				return false
			return type == "Str" ? DllCall(this.Funcs.WriteChar, "Str", params, "Int", len) : DllCall(WriteType[len], type, params)
		}
		CheckType:
		if len is integer
			type := types["Char"]
		else
			type := types[len]
		for k, v in types
		{
			if (type == v)
			{
				isErrorType := false
				break
			}
		}
		return
	}
; BITSTREAM END.

; SFSAMP BEGIN.
	SendChat(msg)
	{
		return DllCall(this.Funcs.SendChat, "Str", msg)
	}
	
	IsInitialized()
	{
		return DllCall(this.Funcs.IsInitialized)
	}
	
	getSAMPAddr()
	{
		return DllCall(this.Funcs.getSAMPAddr, "UInt")
	}
	
	registerChatCommand(command, function)
	{
		if (func_addr := RegisterCallback(function))
		{
			this.CallBackAddr[command] := func_addr
			return DllCall(this.Funcs.registerChatCommand, "Str", command, "UInt", func_addr)
		}
		return false
	}
	
	registerDialogCallback(function)
	{
		if (func_addr := RegisterCallback(function))
		{
			this.CallBackAddr.Push(func_addr)
			return DllCall(this.Funcs.registerDialogCallback, "UInt", func_addr)
		}
		return false
	}
	
	ShowDialog(wDialogId, iStyle, szCaption, szInfo, szButton1, szButton2 := "")
	{
		return DllCall(this.Funcs.ShowDialog, "UShort", wDialogId, "Int", iStyle, "Str", szCaption, "Str", szInfo, "Str", szButton1, "Str", szButton2)
	}
	
	AddChatMessage(color, text)
	{
		return DllCall(this.Funcs.AddChatMessage, "UInt", color, "Str", text)
	}
	
	getLocalPlayerNickName()
	{
		return DllCall(this.Func.getLocalPlayerNickName, "Str")
	}
	
	getLocalPlayerId()
	{
		return DllCall(this.Func.getLocalPlayerId, "Int")
	}
	
	GetPlayerNameById(id)
	{
		return DllCall(this.Funcs.GetPlayerName, "Int", id)
	}

	GetPlayerColor(id)
	{
		return DllCall(this.Funcs.GetPlayerColor, "Int", id, "UInt")
	}
	
	IsPlayerDefined(playerId, check_streamed)
	{
		return DllCall(this.Funcs.IsPlayerDefined, "Int", playerId, "Int", check_streamed)
	}
	
	isDialogOpen()
	{
		return DllCall(this.Funcs.isDialogOpen)
	}
	
	SetDialogOpenStatus(status)
	{
		return DllCall(this.Funcs.SetDialogOpenStatus, "Int", status)
	}
; SFSAMP END.
}