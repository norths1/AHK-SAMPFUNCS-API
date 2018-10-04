#include AHK-SAMPFUNCS-API.ahk

SF.registerDialogCallback("DialogCallback")

!1::
    SF.ShowDialog(2, SF.DIALOG_STYLE_LIST, "Меню", "Пункт 1`n`nПункт 2`nПункт 3", "Назад", "Закрыть")
return

!2::
    SF.ShowDialog(3, SF.DIALOG_STYLE_INPUT, "Меню", "Введите номер:", "Закрыть")
return

DialogCallback(dialogId, buttonId, listItem, input)
{
    GetParamsAsStr(input)
    SF.LogConsole("--------------------")
    SF.LogConsole("dialogId = " dialogId)
    SF.LogConsole("buttonId = " buttonId)
    SF.LogConsole("listItem = " listItem)
    SF.LogConsole("input = " input)
    SF.LogConsole("--------------------")
}