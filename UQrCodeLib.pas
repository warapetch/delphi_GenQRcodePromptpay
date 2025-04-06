unit UQrCodeLib;

interface

uses System.SysUtils, System.StrUtils, System.Classes;

// Ref
// https://www.bot.or.th/content/dam/bot/fipcs/documents/FPG/2562/ThaiPDF/25620084.pdf

var
    // ข้อมูล แต่ละกลุ่มแยกเป็น Tag 00 - 99
    // แต่ละ Tag มีความหมายเฉพาะ และ มีค่าเฉพาะ
    // มีความยาว (Size) เป็นตัวบอกขอบเขตข้อมูล / ความยาว

    // TagID 00 size=02 value=01 (Version 1)
    EMVcoVersion      : String = '000201'; // TagID 00 size=02 value=01
    TID_QRCODE_TYPE   : String = '0102';   // TagID 01 size=02

    // 11 ราคา 0 ไม่กำหนดราคา
    // 12 กำหนดค่า > กว่า 0
    VAL_FIXED_PRICE     : String = '11';

    TID_MERCHANT_TYPE   : String = '29'; // Tag 29  โอนเงินผ่านบริการพร้อมเพย
    VAL_MERCHANT_SUBID  : String = '00'; // sub 00
    VAL_PROMPTPAY_CODE  : String = '16A000000677010111'; // 16 + A000000677010111
    VAL_PROMPTPAY_TYPE  : String = '01';    // 01 [Phone Number] 02 [ID Card] 03 [E-Wallet] 04 [Bank Account]
    VAL_PHONE_CODE      : String = '0066';  // +066
    TID_COUNTRY_CODE    : String = '58';    // Tag 58
    VAL_THAI_COUNTRY_TEXT : String = 'TH';  // Thailand
    TID_CURRENCY        : String = '53';    // Tag 53
    VAL_THAI_CURRENCY   : String = '764';   // Baht
    TID_CHECKSUM        : String = '6304';  // Tag 63 , 63 [CheckSum] + 04 [size]
    TID_PRICE_AMOUNT    : String = '54';    // Tag 54


function generatePayload(promptPayAccNo, amount: String): String;
function getCRC16(Buffer:String):Cardinal;
function getLength00(value:String) : String;

implementation


function getLength00(value: String) : String;
var iLength : smallint;
begin
    iLength := length(value);
    if iLength < 10 then
       result := '0'+IntToStr(iLength)
    else
    result := IntToStr(iLength);

end;

function remove0(value: String):String;
begin
    if value[1] = '0' then
       begin
         repeat
            value := Copy(value,2,length(value));
         until value[1] <> '0';
       end;

    result := value;
end;

function generatePayload(promptPayAccNo, amount: string): string;
var  data , payloadData,
  CheckSumValue : String;
  amountF : Double;

  function getFixedPriceAmount(): String;
  begin
      if amountF = 0.00 then
         Result := ''
      else
      Result := TID_PRICE_AMOUNT+getLength00(amount)+amount;
  end;


begin

  if trim(amount) = '' then
     begin
        amount := '0.00';
     end;

  amountF := StrToFloat(amount);
  amount  := FormatFloat('#.00',amountF);

  VAL_FIXED_PRICE := '11';
  if (amountF > 0) then
      VAL_FIXED_PRICE := '12';

  // PromptPay Account
  VAL_PROMPTPAY_TYPE := '01'; // Phone No
  if Length(promptPayAccNo) = 13 then
     VAL_PROMPTPAY_TYPE := '02'; // IDCard

  if VAL_PROMPTPAY_TYPE = '01' then // Phone No
     // Remove 0 from Phone Number 080... >> 80...
     promptPayAccNo :=  VAL_PHONE_CODE+remove0(promptPayAccNo);


  data := EMVcoVersion+
          TID_QRCODE_TYPE+    // Tag 01 (AccountType) + 02 (Size)
          VAL_FIXED_PRICE+    // 11 or 12
          TID_MERCHANT_TYPE+  // Tag 29
          getLength00(
                TID_MERCHANT_TYPE+
                VAL_PROMPTPAY_CODE+
                VAL_PROMPTPAY_TYPE+
                getLength00(promptPayAccNo)+
                promptPayAccNo
            )+
          VAL_MERCHANT_SUBID+ // 00
          VAL_PROMPTPAY_CODE+ // 16A000000677010111
          VAL_PROMPTPAY_TYPE+ // 01 [Phone No] or 02 [ID Card]
          getLength00(promptPayAccNo)+
          promptPayAccNo+
          TID_COUNTRY_CODE+'02'+VAL_THAI_COUNTRY_TEXT+  // 5802TH
          getFixedPriceAmount()+ // 54+SIZE+PRICE
          TID_CURRENCY+'03'+VAL_THAI_CURRENCY; // 5303764

  payloadData := data;
  // add 63 (CheckSum) + 04 (size)
  CheckSumValue := getCRC16(payloadData+TID_CHECKSUM).ToHexString;

  // remove '0000' >> 0000XXXX
  if length(CheckSumValue) = 8 then  
     CheckSumValue := Copy(CheckSumValue,5,4);

  Result := payloadData+TID_CHECKSUM+CheckSumValue;

end;


function getCRC16(Buffer:String):Cardinal;
// CRC16 xor XModem
const
  polynomial = $1021; // xmodem
var
  i,j: Integer;
begin
    Result:= $FFFF;

    for i:=1 to Length(Buffer) do
        begin
            Result:= Result xor (ord(buffer[i]) shl 8);
            for j:=0 to 7 do
                begin
                    if (Result and $8000)<>0 then
                        Result:= (Result shl 1) xor polynomial
                    else
                        Result:= Result shl 1;
                end;
        end;

    Result:= Result and $ffff;
end;

end.
