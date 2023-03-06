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
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = all;
                }
                field("Substitute Item No."; Rec."Substitute Item No.")
                {
                    ApplicationArea = all;
                }
                field("ECN Date"; Rec."ECN Date")
                {
                    ApplicationArea = all;
                }
                field("Substitute Type"; Rec."Substitute Type")
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
                field("Quantity Per"; Rec."Quantity Per")
                {
                    ApplicationArea = all;
                }
                // field(Quantity; Rec.Quantity)
                // {
                //     ApplicationArea = all;
                // }
                // field("New Quantity"; Rec."New Quantity")
                // {
                //     ApplicationArea = all;
                // }
                field(Status; Rec.Status)
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
                                ECNRecord."No." := eRecordNo;
                                ECNRecord."ECN Date" := eECNDate;
                                ECNRecord."Item No." := eItemNo;
                                ECNRecord."Substitute Item No." := eNewItemNo;
                                ECNRecord.LOCKTABLE;
                                ECNRecord.INSERT(TRUE);
                                ECNRecord.Modify();
                            end else begin
                                ECNRecord."No." := eRecordNo;
                                ECNRecord."ECN Date" := eECNDate;
                                ECNRecord."Item No." := eItemNo;
                                ECNRecord."Substitute Item No." := eNewItemNo;
                                ECNRecord.Modify();
                            end;
                        end;
                    end;
                end;
            }

            action("Prod. Order Lines")
            {
                Caption = 'Prod. Orders';
                Image = OrderList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;

                trigger OnAction()
                var
                    TmpProdOrderLine: Record "Prod. Order Line" temporary;
                    ECNProdOrders: page "ECN Prod. Orders";
                    ECNRecords: Record "ECN Record";
                    ItemStrings: Text[100];
                    ProdOrderLine: Record "Prod. Order Line";
                    ProdOrderComponent: Record "Prod. Order Component";
                    AllComponentsFound: Boolean;
                    window: Dialog;
                begin
                    window.Open('Calculating#1#########');
                    TmpProdOrderLine.Reset();
                    if TmpProdOrderLine.FindFirst() then
                        TmpProdOrderLine.DeleteAll();

                    ProdOrderLine.Reset();
                    ProdOrderLine.SetRange(Status, ProdOrderLine.Status::Released);
                    if ProdOrderLine.FindFirst() then
                        repeat
                            window.Update(1, ProdOrderLine."Prod. Order No.");
                            AllComponentsFound := true;
                            ProdOrderComponent.Reset();
                            ProdOrderComponent.SetRange("Prod. Order No.", ProdOrderLine."Prod. Order No.");
                            ProdOrderComponent.SetRange("Prod. Order Line No.", ProdOrderLine."Line No.");

                            ECNRecords.Reset();
                            ECNRecords.SetRange("No.", Rec."No.");
                            if ECNRecords.FindFirst() then
                                repeat
                                    ECNRecords.TestField("Quantity Per");
                                    ProdOrderComponent.SetRange("Item No.", ECNRecords."Item No.");
                                    if not ProdOrderComponent.FindFirst() then
                                        AllComponentsFound := false;
                                until ECNRecords.Next() = 0;
                            if AllComponentsFound then begin
                                TmpProdOrderLine.Init();
                                TmpProdOrderLine := ProdOrderLine;
                                TmpProdOrderLine."Description 2" := Rec."No.";
                                TmpProdOrderLine.Insert();
                            end;
                        until ProdOrderLine.Next() = 0;
                    window.Close();
                    Commit();
                    TmpProdOrderLine.Reset();
                    if TmpProdOrderLine.FindFirst() then begin
                        Page.Run(Page::"ECN Prod. Orders", TmpProdOrderLine)
                    end else
                        Error('No production orders are found');

                end;
            }

            action("Components")
            {
                Caption = 'Item Components';
                Image = Components;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;

                trigger OnAction()
                var
                    ProdOrderComponentsWH: Page "ECN Item Components";
                    ProdOrderComponent: Record "Prod. Order Component";
                begin
                    ProdOrderComponent.SetRange("Item No.", Rec."Item No.");
                    ProdOrderComponentsWH.SetTableView(ProdOrderComponent);
                    ProdOrderComponentsWH.SetValue(Rec."Item No.", Rec."Substitute Item No.");
                    ProdOrderComponentsWH.RunModal();
                end;
            }
            action("Subs. Item Components")
            {
                Caption = 'Subs. Item Components';
                Image = Components;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;

                trigger OnAction()
                var
                    ProdOrderComponentsWH: Page "ECN Item Components";
                    ProdOrderComponent: Record "Prod. Order Component";
                begin
                    ProdOrderComponent.SetRange("Item No.", Rec."Substitute Item No.");
                    ProdOrderComponentsWH.SetTableView(ProdOrderComponent);
                    ProdOrderComponentsWH.SetValue(Rec."Item No.", Rec."Substitute Item No.");
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

