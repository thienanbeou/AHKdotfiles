#UseHook
#NoEnv
#KeyHistory 0
#MaxHotkeysPerInterval 200
#HotkeyInterval 50
#SingleInstance Force

SendMode Input
SetBatchLines, -1
ListLines, Off
SetWorkingDir %A_ScriptDir%

; -------------------
; Always-active QWERTY maps
; -------------------
CapsLock::LAlt
[::PrintScreen
]::Delete
`::Esc

; -------------------
; Alt-layer activation
; Works with LAlt, RAlt, and CapsLock because CapsLock is remapped to LAlt
; -------------------
layerActive := false

$*LAlt::
$*RAlt::
    layerActive := true
    KeyWait, % SubStr(A_ThisHotkey, 3)
    layerActive := false
return

; -------------------
; Alt-layer mappings
; -------------------
#If (layerActive)

; Number row under QWERTY row
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

; Function keys
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

; Navigation
j::Left
k::Up
l::Down
`;::Right
m::Home
,::End
.::PgUp
/::PgDn

; Symbols
a::AltLayer_A()
f::AltLayer_F()
s::]
d::)
g::\
x::!
z::CapsLock
v::=
c::-
Tab::SendInput ``
+Tab::SendInput ~

; Volume
Left::Volume_Down
Down::Volume_Mute
Right::Volume_Up

#If

; -------------------
; Always-active quote tap dance
; Shift + ' once  -> "
; Shift + ' twice -> "" with cursor inside
; ' without Shift -> '
; -------------------
*'::
    if !GetKeyState("Shift", "P") {
        SendInput '
        return
    }

    TapDance("quote", """", """""" "{Left}")
return

; -------------------
; Tap dance functions
; -------------------

AltLayer_F() {
    TapDance("f", "(", "(){Left}")
}

AltLayer_A() {
    if GetKeyState("Shift", "P") {
        TapDance("a", "{", "{{}{}}{Left}")
    } else {
        TapDance("a", "[", "[]{Left}")
    }
}

TapDance(name, singleOutput, doubleOutput, delay := 200) {
    static lastTap := {}
    static tapCount := {}

    now := A_TickCount

    if (!lastTap.HasKey(name)) {
        lastTap[name] := 0
        tapCount[name] := 0
    }

    if (now - lastTap[name] < delay) {
        tapCount[name] += 1
    } else {
        tapCount[name] := 1
    }

    lastTap[name] := now

    if (tapCount[name] = 2) {
        tapCount[name] := 0
        SetTimer, % name "_SingleTap", Off
        SendInput % doubleOutput
    } else {
        global TapDanceOutputs
        if (!IsObject(TapDanceOutputs))
            TapDanceOutputs := {}

        TapDanceOutputs[name] := singleOutput
        SetTimer, % name "_SingleTap", % -delay
    }
}

f_SingleTap:
a_SingleTap:
quote_SingleTap:
    global TapDanceOutputs

    name := StrReplace(A_ThisLabel, "_SingleTap")

    if (IsObject(TapDanceOutputs) && TapDanceOutputs.HasKey(name)) {
        SendInput % TapDanceOutputs[name]
    }
return
