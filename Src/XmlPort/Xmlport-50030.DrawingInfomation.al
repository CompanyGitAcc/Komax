xmlport 50030 "Drawing Infomation"
{
    Caption = 'Drawing Infomation';
    Direction = Import;
    FieldDelimiter = '"';
    FieldSeparator = ',';
    Format = VariableText;
    FormatEvaluate = Legacy;
    //TextEncoding = WINDOWS;
    TextEncoding = UTF8;

    schema
    {
        textelement(Root)
        {
            tableelement("Extended Text Line"; "Extended Text Line")
            {
                XmlName = 'ExtendedTextLine';
                AutoSave = false;
                textelement(I_ItemNo)
                {
                    MinOccurs = Zero;
                }
                textelement(I_Drawing)
                {
                    MinOccurs = Zero;
                }
                textelement(I_Sheet)
                {
                    MinOccurs = Zero;
                }
                textelement(I_Index)
                {
                    MinOccurs = Zero;
                }
                textelement(I_Remark1)
                {
                    MinOccurs = Zero;
                }
                textelement(I_Remark2)
                {
                    MinOccurs = Zero;
                }
                textelement(I_Remark3)
                {
                    MinOccurs = Zero;
                }
                textelement(I_Remark4)
                {
                    MinOccurs = Zero;
                }
                textelement(I_Remark5)
                {
                    MinOccurs = Zero;
                }
                textelement(I_Remark6)
                {
                    MinOccurs = Zero;
                }
                textelement(I_Remark7)
                {
                    MinOccurs = Zero;
                }
                trigger OnBeforeInsertRecord()
                begin

                    I_Index := DELCHR(I_Index, '=', ' ');
                    IF STRLEN(I_Index) = 0 THEN
                        I_Index := '000'
                    ELSE
                        IF STRLEN(I_Index) = 1 THEN
                            I_Index := '00' + I_Index
                        ELSE
                            IF STRLEN(I_Index) = 2 THEN
                                I_Index := '0' + I_Index;


                    Grcd_ExtendHeader.RESET;
                    Grcd_ExtendHeader.SETRANGE(Grcd_ExtendHeader."Table Name", Grcd_ExtendHeader."Table Name"::Item);
                    Grcd_ExtendHeader.SETRANGE(Grcd_ExtendHeader."No.", I_ItemNo);
                    Grcd_ExtendHeader.SETRANGE(Grcd_ExtendHeader."Text No.", 1);
                    Grcd_ExtendHeader.SETRANGE(Grcd_ExtendHeader."All Language Codes", TRUE);
                    IF NOT Grcd_ExtendHeader.FIND('-') THEN BEGIN
                        Window.UPDATE(1, 'Extended Text Header');
                        Window.UPDATE(2, I_ItemNo);
                        Grcd_ExtendHeader.INIT;
                        Grcd_ExtendHeader."Table Name" := Grcd_ExtendHeader."Table Name"::Item;
                        Grcd_ExtendHeader."No." := I_ItemNo;
                        Grcd_ExtendHeader."Text No." := 1;
                        Grcd_ExtendHeader."All Language Codes" := TRUE;
                        Grcd_ExtendHeader."Sales Quote" := TRUE;
                        Grcd_ExtendHeader."Sales Order" := TRUE;
                        Grcd_ExtendHeader."Purchase Order" := TRUE;
                        Grcd_ExtendHeader.INSERT;
                    END;

                    Grcd_ExtendLine.RESET;
                    Grcd_ExtendLine.SETRANGE(Grcd_ExtendLine."Table Name", Grcd_ExtendLine."Table Name"::Item);
                    Grcd_ExtendLine.SETRANGE(Grcd_ExtendLine."No.", I_ItemNo);
                    Grcd_ExtendLine.SETRANGE(Grcd_ExtendLine."Text No.", 1);
                    IF Grcd_ExtendLine.FIND('+') THEN BEGIN
                        Window.UPDATE(1, 'Extended Text Line');
                        Window.UPDATE(2, I_ItemNo);
                        Gint_LineNo := Grcd_ExtendLine."Line No.";
                        Grcd_ExtendLine.INIT;
                        Grcd_ExtendLine."Table Name" := Grcd_ExtendLine."Table Name"::Item;
                        Grcd_ExtendLine."No." := I_ItemNo;
                        Grcd_ExtendLine."Text No." := 1;
                        Grcd_ExtendLine."Line No." := Gint_LineNo + 10000;
                        Grcd_ExtendLine.Text := I_Drawing;
                        Grcd_ExtendLine.Sheet := I_Sheet;
                        Grcd_ExtendLine.Index := I_Index;
                        Grcd_ExtendLine."Apply To Order" := TRUE;
                        Grcd_ExtendLine.INSERT;
                    END
                    ELSE BEGIN
                        Gint_LineNo := 0;
                        Grcd_ExtendLine.INIT;
                        Grcd_ExtendLine."Table Name" := Grcd_ExtendLine."Table Name"::Item;
                        Grcd_ExtendLine."No." := I_ItemNo;
                        Grcd_ExtendLine."Text No." := 1;
                        Grcd_ExtendLine."Line No." := Gint_LineNo + 10000;
                        Grcd_ExtendLine.Text := I_Drawing;
                        Grcd_ExtendLine.Sheet := I_Sheet;
                        Grcd_ExtendLine.Index := I_Index;
                        Grcd_ExtendLine."Apply To Order" := TRUE;
                        Grcd_ExtendLine.INSERT;
                    END;
                    // CurrDataport.SKIP;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnPreXmlPort()
    begin
        Window.OPEN('Process #1################## \' +
                   'Item No.#2##################');
    end;

    trigger OnPostXmlPort()
    begin
        Window.Close();
    end;

    var
        Window: Dialog;
        Grcd_ExtendHeader: Record "Extended Text Header";
        Grcd_ExtendLine: Record "Extended Text Line";
        Grcd_ExtendLineDelete: Record "Extended Text Line";
        Gint_LineNo: Integer;
    // I_ItemNo: Code[20];
    // I_Drawing: Text[100];
    // I_Sheet: Text[30];
    // I_Index: Code[20];
    // I_Remark1: Text[30];
    // I_Remark2: Text[30];
    // I_Remark3: Text[30];
    // I_Remark4: Text[30];
    // I_Remark5: Text[30];
    // I_Remark6: Text[30];
    // I_Remark7: Text[30];
}
