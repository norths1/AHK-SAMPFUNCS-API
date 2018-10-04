#include AHK-SAMPFUNCS-API.ahk

SF.registerRakNetCallback(SF.RAKHOOK_TYPE_INCOMING_RPC, "IncomingRPC")

IncomingRPC(params)
{
    critical ; Предотвращает прерывание текущего потока другими потоками.
    BS := SF.BitStream(params)
    if (BS.packetId == SF.RPC_ScrClientMessage)
    {
        BS.ResetReadPointer()
        BS.Read(color, "DWORD")
        BS.Read(length, "DWORD")
        BS.Read(text, length)
        BS.ResetReadPointer()
        SF.LogConsole("color = " DecToHex(color) " | text = " text)
        return false ; Игнорируем RPC.
    }
    return true ; Успешно завершаем обработку RPC.
}