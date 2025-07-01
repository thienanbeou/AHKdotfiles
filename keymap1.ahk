#UseHook
#MaxHotkeysPerInterval 200
#HotkeyInterval 50
#KeyHistory 0
SetBatchLines, -1
ListLines, Off

#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

; -------------------
; QWERTY maps
; -------------------
CapsLock::LAlt
[::PrintScreen
]::Delete
::Esc

; -------------------
; Alt-layer toggle (both LAlt and RAlt)
; -------------------
layerActive := false

$*LAlt::
layerActive := true
KeyWait, LAlt
layerActive := false
return

$*RAlt::
layerActive := true
KeyWait, RAlt
layerActive := false
return

; -------------------
; Alt-layer mappings (only active while holding Alt)
; -------------------
#If (layerActive)
q::1
w::2
e::3
r::4
t::5
y::6
u::7
i::8
o::9
p::0

1::F1
2::F2
3::F3
4::F4
5::F5
6::F6
7::F7
8::F8
9::F9
0::F10
-::F11
=::F12

j::Left
k::Up
l::Down
;::Right

s::]
d::)

g::\
z::CapsLock
v::=
c::-
Tab::Send, `
Left::Volume_Down
Down::Volume_Mute
Right::Volume_Up

; Tap dance for f
*f::
    global f_lastTap, f_tapCount
    if (!f_lastTap) {
        f_lastTap := 0
        f_tapCount := 0
    }

    if (A_TickCount - f_lastTap < 200) {
        f_tapCount += 1
    } else {
        f_tapCount := 1
    }
    f_lastTap := A_TickCount

    if (f_tapCount = 2) {
        f_tapCount := 0
        SetTimer, f_singleTap, Off
        SendInput (){Left}
    } else {
        SetTimer, f_singleTap, -200
    }
return

f_singleTap:
    SendInput (
return

; Tap dance for a
*a::
    global a_lastTap, a_tapCount
    if (!a_lastTap) {
        a_lastTap := 0
        a_tapCount := 0
    }

    if (A_TickCount - a_lastTap < 200) {
        a_tapCount += 1
    } else {
        a_tapCount := 1
    }
    a_lastTap := A_TickCount

    if (a_tapCount = 2) {
        a_tapCount := 0
        SetTimer, a_singleTap, Off

        if GetKeyState("Shift", "P") {
            SendInput {{}{}}{Left}
        } else {
            SendInput []{Left}
        }
    } else {
        SetTimer, a_singleTap, -200
    }
return

a_singleTap:
    if GetKeyState("Shift", "P") {
        SendInput {
    } else {
        SendInput [
    }
return
#If  ; End of Alt-layer block

; -------------------
; Double quote tap dance (Shift + ')
; -------------------
*'::  ; Always active
    if !GetKeyState("Shift", "P") {
        SendInput '
        return
    }

    global quote_lastTap, quote_tapCount
    if (!quote_lastTap) {
        quote_lastTap := 0
        quote_tapCount := 0
    }

    if (A_TickCount - quote_lastTap < 200) {
        quote_tapCount += 1
    } else {
        quote_tapCount := 1
    }
    quote_lastTap := A_TickCount

    if (quote_tapCount = 2) {
        quote_tapCount := 0
        SetTimer, quote_singleTap, Off
        SendInput ""{Left}
    } else {
        SetTimer, quote_singleTap, -200
    }
return

quote_singleTap:
    SendInput "
return
