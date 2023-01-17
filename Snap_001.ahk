#NoEnv

SetWorkingDir %A_ScriptDir%

#SingleInstance Force

;CoordMode,Pixel, Window
;CoordMode,Mouse, Window
CoordMode,Pixel, Screen
CoordMode,Mouse, Screen

global StartTime := 0
global SnapStartTime := 0
global GameCount := 0
global SnapRestartCount := 0
global isMouseMove := "true"

CheckH := 1080
CheckW := 960 ; half

RestartGame() {
	ImageSearch, xx, yy, 0, 0, CheckW, CheckH, x.png
	;MsgBox, %ErrorLevel%
	If ErrorLevel = 0
	{
		;마우스 위치 저장
		if (isMouseMove = "true")
			MouseGetPos, mx, my

		Click, %xx%, %yy% Left    ;, 1

		;마우스 위치 복원
		if (isMouseMove = "true")
			Mousemove, mx, my

		sleep, 10000

	}
	else
	{
		;마우스 위치 저장
		if (isMouseMove = "true")
			MouseGetPos, mx, my

		Click, 745, 13 Left     ;, 1

		;마우스 위치 복원
		if (isMouseMove = "true")
			Mousemove, mx, my

		sleep, 10000
	}
	StartGame()
	Return
}

StartGame() {
	Run, steam://rungameid/1997040
	sleep, 15000
	FormatTime, StartTime,, yyyyMMddHHmm
	FormatTime, SnapStartTime,, yyyyMMddHHmm
	Return
}

GameStopCheck()	{	;5분간 새 게임이 시작안되면 Snap 재실행
	;If EndFlag != PlayFlag
	FormatTime, CurrentTime,,yyyyMMddHHmm
	; 2023.01.12 5분 --> 7 분으로 변경
	If (StartTime != 0 and StartTime < CurrentTime -7)
	{
		RestartGame()
		Run, steam://rungameid/1997040
		SnapRestartCount += 1
	}
	Return
}

F1::		;INFO
	;MsgBox, PlayFlag:%PlayFlag%,EndFlag:%EndFlag%
	;FormatTime, CurrentTime,, yyyyMMddHHmm

	FormatTime, CurrentTime,, yyyyMMddHHmm
	; 2023.01.12 5분 --> 7 분으로 변경
	If (StartTime != 0 and StartTime < CurrentTime - 7) {
		;MsgBox, "Restart required"
		resultMsg := "Restart Required"
	} else {
		;MsgBox, "Stay"
		resultMsg := "Stay"
	}
	MsgBox, GameStartTime: %StartTime%`nSnapStartTime: %SnapStartTime%`nGameCount: %GameCount%`nstate: %resultMsg%`nSnapRestartCount: %SnapRestartCount%

	Return
F4::		; restart game
	RestartGame()
	Return
F5::		;실행
	FormatTime, StartTime,, yyyyMMddHHmm
	;SetTimer, GameStopCheck, 300000	; 5 minute
	Loop {

		FormatTime, CurrentTime,, yyyyMMddHHmm
		If (StartTime < CurrentTime - 5)
		{
			RestartGame()      ; Snap 재시작
		}

		ImageSearch, xx, yy, 0, 0, CheckW, CheckH, pl_1.png ;플레이
		If ErrorLevel = 0
		{
			sleep, 1000
			;마우스 위치 저장
			if (isMouseMove = "true")
				MouseGetPos, mx, my

			Click, %xx%, %yy% Left     ;, 1

			;마우스 위치 복원
			if (isMouseMove = "true")
				Mousemove, mx, my

			; 시작시간 기록
			FormatTime, StartTime,, yyyyMMddHHmm
			GameCount += 1

			;MouseMove, 700,700,10
			sleep, 3000

		}

		;ImageSearch, xx, yy, 0, 0, CheckW, CheckH, t1.png ; 턴종료
		ImageSearch, xx, yy, 570, 930, CheckW, CheckH, t1.png ; 턴종료
		If ErrorLevel = 0
		{
			sleep, 1000

			;마우스 위치 저장
			if (isMouseMove = "true")
				MouseGetPos, mx, my

			Click, %xx%, %yy% Left     ;, 1
			;MouseMove, 700,700,10

			;마우스 위치 복원
			if (isMouseMove = "true")
				Mousemove, mx, my

			sleep, 3000
		}
		; 2023.01.11부터 좌표를 못찾고 있음. (n1.png), n2.png로 변경해봄 좌표도 조정 (271,920 , 482,999)
		;ImageSearch, xx, yy, 0, 0, CheckW, CheckH, n1.png ; 다음(게임끝)
		ImageSearch, xx, yy, 271, 920, CheckW, CheckH, n2.png ; 다음(게임끝)
		If ErrorLevel = 0
		{
			sleep, 1000
			;마우스 위치 저장
			if (isMouseMove = "true")
				MouseGetPos, mx, my

			Click, %xx%, %yy% Left   ;, 1
			;MouseMove, 700,700,10

			;마우스 위치 복원
			if (isMouseMove = "true")
				Mousemove, mx, my

			sleep, 3000
		}

		; 2023.01.12동기화 불가 팝업이 가끔 뜸.   [무시하고 계속 플레이]
		;ImageSearch, xx, yy, 0, 0, CheckW, CheckH, n1.png ; 다음(게임끝)
		ImageSearch, xx, yy, 0, 0, 1980, 1040, musi.png ; 무시
		If ErrorLevel = 0
		{
			sleep, 1000
			;마우스 위치 저장
			if (isMouseMove = "true")
				MouseGetPos, mx, my

			Click, %xx%, %yy% Left   ;, 1
			;MouseMove, 700,700,10

			;마우스 위치 복원
			if (isMouseMove = "true")
				Mousemove, mx, my

			sleep, 3000
		} else {
			ImageSearch, xx, yy, 0, 0, 1980, 1040, musi_over.png ; 무시 (마우스 오버시 색상 달라짐)
			If ErrorLevel = 0
			{
				sleep, 1000
				;마우스 위치 저장
				if (isMouseMove = "true")
					MouseGetPos, mx, my

				Click, %xx%, %yy% Left   ;, 1
				;MouseMove, 700,700,10

				;마우스 위치 복원
				if (isMouseMove = "true")
					Mousemove, mx, my

				sleep, 3000
			}
		}
		sleep, 2000
	} ; Loop end

	Return

F11::ExitApp			;종료

F2::pause
	;SetTimer,GameStopCheck, Off
	;pause
	;Return
F12::Reload		;재시작