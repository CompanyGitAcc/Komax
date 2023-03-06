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
        //负数判断
        if StrPos(num, '-') <> 0 then begin
            num := DelStr(num, StrPos(num, '-'), 1);
            IsNegative := true;
        end;

        //小数补零
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
                        strUpart := '圆';

                    end;
                '0':
                    begin
                        strUpart := '零';

                    end;
                '1':
                    begin
                        strUpart := '壹';

                    end;
                '2':
                    begin
                        strUpart := '贰';

                    end;
                '3':
                    begin
                        strUpart := '叁';

                    end;
                '4':
                    begin
                        strUpart := '肆';

                    end;
                '5':
                    begin
                        strUpart := '伍';

                    end;
                '6':
                    begin
                        strUpart := '陆';

                    end;
                '7':
                    begin
                        strUpart := '柒';

                    end;
                '8':
                    begin
                        strUpart := '捌';

                    end;
                '9':
                    begin
                        strUpart := '玖';

                    end;
            end;
            case iTemp of
                1:
                    begin
                        strUpart := strUpart + '分';
                    end;
                2:
                    begin
                        strUpart := strUpart + '角';
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
                        strUpart := strUpart + '拾';
                    end;
                6:
                    begin
                        strUpart := strUpart + '佰';
                    end;
                7:
                    begin
                        strUpart := strUpart + '仟';
                    end;
                8:
                    begin
                        strUpart := strUpart + '万';
                    end;
                9:
                    begin
                        strUpart := strUpart + '拾';
                    end;
                10:
                    begin
                        strUpart := strUpart + '佰';
                    end;
                11:
                    begin
                        strUpart := strUpart + '仟';
                    end;

                12:
                    begin
                        strUpart := strUpart + '亿';
                    end;
                13:
                    begin
                        strUpart := strUpart + '拾';
                    end;
                14:
                    begin
                        strUpart := strUpart + '佰';
                    end;
                15:
                    begin
                        strUpart := strUpart + '仟';
                    end;
                16:
                    begin
                        strUpart := strUpart + '万';
                    end;
            end;
            strUpper := strUpart + strUpper;
            iTemp := iTemp + 1;
        end;

        strUpper := strUpper.Replace('零拾', '零');
        strUpper := strUpper.Replace('零佰', '零');
        strUpper := strUpper.Replace('零仟', '零');
        strUpper := strUpper.Replace('零零零', '零');
        strUpper := strUpper.Replace('零零', '零');
        strUpper := strUpper.Replace('零角零分', '整');
        strUpper := strUpper.Replace('零分', '整');
        strUpper := strUpper.Replace('零角', '零');
        strUpper := strUpper.Replace('零亿零万零圆', '亿圆');
        strUpper := strUpper.Replace('亿零万零圆', '亿圆');
        strUpper := strUpper.Replace('零亿零万', '亿');
        strUpper := strUpper.Replace('零万零圆', '万圆');
        strUpper := strUpper.Replace('零亿', '亿');
        strUpper := strUpper.Replace('零万', '万');
        strUpper := strUpper.Replace('零圆', '圆');
        strUpper := strUpper.Replace('零零', '零');

        // 对壹圆以下的金额的处理

        if (CopyStr(strUpper, 1, 1) = '圆') then
            strUpper := CopyStr(strUpper, 1, strlen(strUpper));

        if (CopyStr(strUpper, 1, 1) = '零') then
            strUpper := CopyStr(strUpper, 1, strlen(strUpper));
        if (CopyStr(strUpper, 1, 1) = '角') then
            strUpper := CopyStr(strUpper, 1, strlen(strUpper));
        if (CopyStr(strUpper, 1, 1) = '分') then
            strUpper := CopyStr(strUpper, 1, strlen(strUpper));
        if (CopyStr(strUpper, 1, 1) = '整') then
            strUpper := '零圆整';
        functionReturnValue := strUpper;

        if (IsNegative = true) then
            exit('负' + functionReturnValue)
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
