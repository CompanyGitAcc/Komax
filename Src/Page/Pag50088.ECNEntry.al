page 50088 "ECN Record"
{
    PageType = List;
    SourceTable = "ECN Record";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Record No."; Rec."Record No.")
                {
                    ApplicationArea = all;
                }
                field("ECN Date"; Rec."ECN Date")
                {
                    ApplicationArea = all;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = all;
                }
                field("New Item No."; Rec."New Item No.")
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }
                field(Inventory; Rec.Inventory)
                {
                    ApplicationArea = all;
                }
                field("New Item Inventory"; Rec."New Item Inventory")
                {
                    ApplicationArea = all;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                }
                field("New Quantity"; Rec."New Quantity")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Import ECN")
            {
                // record No / ECN date /item no / new item no
                Caption = 'Import ECN';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;
                trigger OnAction()
                var
                    Buffer: Record "Excel Buffer" temporary;
                    Buffer2: Record "Excel Buffer" temporary;
                    ECNRecord: Record "ECN Record";
                    ExcelUtil: Codeunit "TP Utilities";
                    InS: InStream;
                    Filename: Text;
                    Row: Integer;
                    LastRow: Integer;
                    eRecordNo: Code[20];         //Column-A/1
                    eECNDate: date;             //Column-B/2
                    eItemNo: Code[20];          //Column-C/3
                    eNewItemNo: Code[20];           //Column-D/4
                    Window: Dialog;
                    LastLineNo: Integer;
                    Item: Record Item;
                begin
                    if UploadIntoStream('Import Sales Order', '', '', Filename, InS) then begin
                        LastLineNo := 0;
                        Buffer.OpenBookStream(InS, 'Sheet1');
                        Buffer.ReadSheet();
                        Buffer.FindLast();
                        LastRow := Buffer."Row No.";
                        Buffer.Reset();

                        Window.open('#1##########');
                        for row := 2 to LastRow do begin
                            eRecordNo := ExcelUtil.GetCellText(Buffer, 1, Row);
                            Evaluate(eECNDate, ExcelUtil.GetCellText(Buffer, 2, Row));
                            eItemNo := ExcelUtil.GetCellText(Buffer, 3, Row);
                            eNewItemNo := ExcelUtil.GetCellText(Buffer, 4, Row);

                            //insert Material
                            if not ECNRecord.get(eRecordNo) then begin
                                ECNRecord.init;
                                ECNRecord."Record No." := eRecordNo;
                                ECNRecord."ECN Date" := eECNDate;
                                ECNRecord."Item No." := eItemNo;
                                ECNRecord."New Item No." := eNewItemNo;
                                ECNRecord.LOCKTABLE;
                                ECNRecord.INSERT(TRUE);
                                ECNRecord.Modify();
                            end else begin
                                ECNRecord."Record No." := eRecordNo;
                                ECNRecord."ECN Date" := eECNDate;
                                ECNRecord."Item No." := eItemNo;
                                ECNRecord."New Item No." := eNewItemNo;
                                ECNRecord.Modify();
                            end;
                        end;
                    end;
                end;
            }

            action("Old Item Component")
            {
                Caption = 'Old Item Component';
                Image = Components;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;

                trigger OnAction()
                var
                    ProdOrderComponentsWH: Page "Prod. Order Components-WH";
                    ProdOrderComponent: Record "Prod. Order Component";
                begin
                    ProdOrderComponent.SetRange("Item No.", Rec."Item No.");
                    ProdOrderComponentsWH.SetTableView(ProdOrderComponent);
                    ProdOrderComponentsWH.SetValue(Rec."Item No.", Rec."New Item No.");
                    ProdOrderComponentsWH.RunModal();
                end;
            }
            action("New Item Component")
            {
                Caption = 'New Item Component';
                Image = Components;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;

                trigger OnAction()
                var
                    ProdOrderComponentsWH: Page "Prod. Order Components-WH";
                    ProdOrderComponent: Record "Prod. Order Component";
                begin
                    ProdOrderComponent.SetRange("Item No.", Rec."New Item No.");
                    ProdOrderComponentsWH.SetTableView(ProdOrderComponent);
                    ProdOrderComponentsWH.SetValue(Rec."Item No.", Rec."New Item No.");
                    ProdOrderComponentsWH.RunModal();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        // Rec.SetFilter("Temp Out", '*%1*', '临时出库');
    end;
}

