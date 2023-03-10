codeunit 50011 "TP Utilities"
{
    //==================================================================================================
    //Selection Filter
    //==================================================================================================
    procedure GetSelectionFilterForSalesLine(VAR SalesLine: Record "Sales Line"): Text
    Var
        RecRef: RecordRef;
        SelectFilterMgt: Codeunit SelectionFilterManagement;
    begin
        RecRef.GETTABLE(SalesLine);
        EXIT(SelectFilterMgt.GetSelectionFilter(RecRef, SalesLine.FIELDNO("Line No.")));
    end;

    procedure GetSelectionFilterForPurchRcptLine(VAR PurchRcptLine: Record "Purch. Rcpt. Line"): Text
    Var
        RecRef: RecordRef;
        SelectFilterMgt: Codeunit SelectionFilterManagement;
    begin
        RecRef.GETTABLE(PurchRcptLine);
        EXIT(SelectFilterMgt.GetSelectionFilter(RecRef, PurchRcptLine.FIELDNO("Line No.")));
    end;

    procedure GetSelectionFilterForILE(VAR ILE: Record "Item Ledger Entry"): Text
    Var
        RecRef: RecordRef;
        SelectFilterMgt: Codeunit SelectionFilterManagement;
    begin
        RecRef.GETTABLE(ILE);
        EXIT(SelectFilterMgt.GetSelectionFilter(RecRef, ILE.FIELDNO("Entry No.")));
    end;

    //==================================================================================================
    //Excel Import Utilities
    //==================================================================================================
    procedure GetCellText(var Buffer: Record "Excel Buffer" temporary; Col: Integer; Row: Integer): Text;
    var
    begin
        if Buffer.get(Row, col) then
            exit(Buffer."Cell Value as Text");
    end;

    procedure GetCellDate(var Buffer: Record "Excel Buffer" temporary; Col: Integer; Row: Integer): Date;
    var
        d: Date;
    begin
        if Buffer.get(Row, col) then begin
            Evaluate(D, Buffer."Cell Value as Text");
            exit(D);
        end;
    end;

    procedure GetCellDecimal(var Buffer: Record "Excel Buffer" temporary; Col: Integer; Row: Integer): Decimal;
    var
        d: Decimal;
    begin
        if Buffer.get(Row, col) then begin
            Evaluate(D, Buffer."Cell Value as Text");
            exit(D);
        end;
    end;

    procedure AmountInCapital(numP: Decimal): text[50]
    var
        functionReturnValue: Text[50];
        IsNegative: Boolean;
        strLower: Text[50];
        strUpart: Text[50];
        strUpper: Text[50];
        iTemp: Integer;
        num: Text[50];
    begin
        num := Format(numP, 0, 1);
        //????????????
        if StrPos(num, '-') <> 0 then begin
            num := DelStr(num, StrPos(num, '-'), 1);
            IsNegative := true;
        end;

        //????????????
        if StrPos(num, '.') <> 0 then begin
            if StrPos(num, '.') = StrLen(num) - 1 then
                num := num + '0';
        end else
            num := num + '.00';

        strLower := num;
        iTemp := 1;
        strUpper := '';
        while (iTemp <= strlen(strLower)) do begin
            case Copystr(strLower, strlen(strLower) - iTemp + 1, 1) of
                '.':
                    begin
                        strUpart := '???';

                    end;
                '0':
                    begin
                        strUpart := '???';

                    end;
                '1':
                    begin
                        strUpart := '???';

                    end;
                '2':
                    begin
                        strUpart := '???';

                    end;
                '3':
                    begin
                        strUpart := '???';

                    end;
                '4':
                    begin
                        strUpart := '???';

                    end;
                '5':
                    begin
                        strUpart := '???';

                    end;
                '6':
                    begin
                        strUpart := '???';

                    end;
                '7':
                    begin
                        strUpart := '???';

                    end;
                '8':
                    begin
                        strUpart := '???';

                    end;
                '9':
                    begin
                        strUpart := '???';

                    end;
            end;
            case iTemp of
                1:
                    begin
                        strUpart := strUpart + '???';
                    end;
                2:
                    begin
                        strUpart := strUpart + '???';
                    end;
                3:
                    begin
                        strUpart := strUpart + '';
                    end;
                4:
                    begin
                        strUpart := strUpart + '';
                    end;
                5:
                    begin
                        strUpart := strUpart + '???';
                    end;
                6:
                    begin
                        strUpart := strUpart + '???';
                    end;
                7:
                    begin
                        strUpart := strUpart + '???';
                    end;
                8:
                    begin
                        strUpart := strUpart + '???';
                    end;
                9:
                    begin
                        strUpart := strUpart + '???';
                    end;
                10:
                    begin
                        strUpart := strUpart + '???';
                    end;
                11:
                    begin
                        strUpart := strUpart + '???';
                    end;

                12:
                    begin
                        strUpart := strUpart + '???';
                    end;
                13:
                    begin
                        strUpart := strUpart + '???';
                    end;
                14:
                    begin
                        strUpart := strUpart + '???';
                    end;
                15:
                    begin
                        strUpart := strUpart + '???';
                    end;
                16:
                    begin
                        strUpart := strUpart + '???';
                    end;
            end;
            strUpper := strUpart + strUpper;
            iTemp := iTemp + 1;
        end;

        strUpper := strUpper.Replace('??????', '???');
        strUpper := strUpper.Replace('??????', '???');
        strUpper := strUpper.Replace('??????', '???');
        strUpper := strUpper.Replace('?????????', '???');
        strUpper := strUpper.Replace('??????', '???');
        strUpper := strUpper.Replace('????????????', '???');
        strUpper := strUpper.Replace('??????', '???');
        strUpper := strUpper.Replace('??????', '???');
        strUpper := strUpper.Replace('??????????????????', '??????');
        strUpper := strUpper.Replace('???????????????', '??????');
        strUpper := strUpper.Replace('????????????', '???');
        strUpper := strUpper.Replace('????????????', '??????');
        strUpper := strUpper.Replace('??????', '???');
        strUpper := strUpper.Replace('??????', '???');
        strUpper := strUpper.Replace('??????', '???');
        strUpper := strUpper.Replace('??????', '???');

        // ?????????????????????????????????

        if (CopyStr(strUpper, 1, 1) = '???') then
            strUpper := CopyStr(strUpper, 1, strlen(strUpper));

        if (CopyStr(strUpper, 1, 1) = '???') then
            strUpper := CopyStr(strUpper, 1, strlen(strUpper));
        if (CopyStr(strUpper, 1, 1) = '???') then
            strUpper := CopyStr(strUpper, 1, strlen(strUpper));
        if (CopyStr(strUpper, 1, 1) = '???') then
            strUpper := CopyStr(strUpper, 1, strlen(strUpper));
        if (CopyStr(strUpper, 1, 1) = '???') then
            strUpper := '?????????';
        functionReturnValue := strUpper;

        if (IsNegative = true) then
            exit('???' + functionReturnValue)
        else
            exit(functionReturnValue);
    end;

    procedure GetCreatedByName(CreatedBy: Text[100]): Code[50]
    var
        User: Record User;
    begin
        If User.Get(CreatedBy) Then
            exit(User."User Name");
    end;

}
