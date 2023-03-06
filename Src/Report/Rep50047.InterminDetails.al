report 50047 "Intermin Details"
{
    Caption = 'Intermin Details';
    ProcessingOnly = true;
    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            RequestFilterFields = "G/L Account No.", "Posting Date";
            dataitem("G/L - Item Ledger Relation"; "G/L - Item Ledger Relation")
            {
                DataItemTableView = SORTING("G/L Entry No.", "Value Entry No.");
                DataItemLink = "G/L Entry No." = FIELD("Entry No.");
                dataitem("Value Entry"; "Value Entry")
                {
                    DataItemTableView = SORTING("Entry No.");
                    DataItemLink = "Entry No." = FIELD("Value Entry No.");
                    trigger OnAfterGetRecord()
                    var
                        lrecInterminDetails2: Record "Intermin Details";
                    begin
                        ValueEntryCount := ValueEntryCount + 1;
                        lrecInterminDetails.RESET;
                        lrecInterminDetails.SETRANGE(lrecInterminDetails."Document Type", "Value Entry"."Document Type");
                        lrecInterminDetails.SETRANGE(lrecInterminDetails."Source Type", "Value Entry"."Source Type");
                        lrecInterminDetails.SETRANGE(lrecInterminDetails."Source No.", "Value Entry"."Source No.");
                        lrecInterminDetails.SETRANGE(lrecInterminDetails."Item No.", "Value Entry"."Item No.");
                        IF NOT lrecInterminDetails.FIND('-') THEN BEGIN
                            lrecInterminDetails2.INIT;
                            lrecInterminDetails2."Document Type" := "Value Entry"."Document Type";
                            lrecInterminDetails2."Source Type" := "Value Entry"."Source Type";
                            lrecInterminDetails2."Source No." := "Value Entry"."Source No.";
                            lrecInterminDetails2."Item No." := "Value Entry"."Item No.";
                            lrecInterminDetails2."Item Ledger Entry Quantity" := "Item Ledger Entry Quantity";
                            lrecInterminDetails2."Invoiced Quantity" := "Invoiced Quantity";
                            lrecInterminDetails2."G/L Amount" := "G/L Entry".Amount;
                            lrecInterminDetails2."Posting Filter" := PostingDateFilter;
                            lrecInterminDetails2."GLAcc No. Filter" := GLAccFilter;
                            lrecInterminDetails2.INSERT;
                        END ELSE BEGIN
                            lrecInterminDetails."Item Ledger Entry Quantity" += "Item Ledger Entry Quantity";
                            lrecInterminDetails."Invoiced Quantity" += "Invoiced Quantity";
                            lrecInterminDetails."G/L Amount" += "G/L Entry".Amount;
                            lrecInterminDetails.MODIFY;
                        END;
                    end;
                }
            }

            trigger OnPreDataItem()
            begin
                GLAccFilter := "G/L Entry".GETFILTER("G/L Entry"."G/L Account No.");
                PostingDateFilter := "G/L Entry".GETFILTER("Posting Date");

                Window.OPEN('Data analysis.........\' +
                            'Current row: ###1#####\' +
                            '  Total row: ###2#####');
                Window.UPDATE(1, 0);
                GLEntryCount := "G/L Entry".COUNT;
                Window.UPDATE(2, "G/L Entry".COUNT);
                ValueEntryCount := 0;
            end;

            trigger OnAfterGetRecord()
            begin
                Currow := Currow + 1;
                Window.UPDATE(1, Currow);
            end;

            trigger OnPostDataItem()
            begin
                Window.CLOSE;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    var
        Window: Dialog;
        GLAccFilter: Text[100];
        ExportToExcel: Boolean;
        TempExcelBuffer: Record "Excel Buffer";
        RowNo: Integer;
        PostingDateFilter: Text[100];
        TotalRow: Integer;
        Currow: Integer;
        lrecInterminDetails: Record "Intermin Details";
        ValueEntryCount: Integer;
        GLEntryCount: Integer;
}
