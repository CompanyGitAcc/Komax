pageextension 59045 "TP Purchase Order" extends "Purchase Order"
{
    //------------------------------------------------------------
    //#VOL1.00 - ALF - 2021/11/25
    //增加字段：Project No./Name, "Sales Order No."
    //------------------------------------------------------------       
    layout
    {

        addafter(Status)
        {
            //-----------------------------------------------------------
            //#VOL1.00 - ALF - 2021/12/4
            //PO上增加： WorkDescription相关功能
            //------------------------------------------------------------             
            group("Work Description")
            {
                Caption = 'Work Description';
                field(WorkDescription; WorkDescription)
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    MultiLine = true;
                    ShowCaption = false;

                    trigger OnValidate()
                    begin
                        Rec.SetWorkDescription(WorkDescription);
                    end;
                }
            }
        }
        addlast(General)
        {

            field(SystemCreatedBy; TPUtilities.GetCreatedByName(Rec.SystemCreatedBy))
            {
                Caption = 'Created By';
            }
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                Caption = 'Created At';
            }
            field("Order Type"; Rec."Order Type")
            {
                ApplicationArea = all;
                ShowMandatory = true;
            }
            field("Partial Delivery"; Rec."Partial Delivery")
            {
                ApplicationArea = all;
            }
            field("Forwarder"; Rec."Forwarder")
            {
                ApplicationArea = all;
            }
            field("Way of Dispatch"; Rec."Way of Dispatch")
            {
                ApplicationArea = all;
                ShowMandatory = true;
                Importance = Additional;
            }
            // field("JinSui Invoice No."; Rec."JinSui Invoice No.")
            // {
            //     ApplicationArea = all;
            // }
            field("Everything Is Invoiced"; Rec."Everything Is Invoiced")
            {
                ApplicationArea = all;
            }
            field("Outstanding Amount (Inc. VAT)"; Rec."Outstanding Amount (Inc. VAT)")
            {
                ApplicationArea = all;
            }
            field("Mat. Rcvd not Ivcd (Inc. VAT)"; Rec."Mat. Rcvd not Ivcd (Inc. VAT)")
            {
                ApplicationArea = all;
            }
            field(Amount; Rec.Amount)
            {
                ApplicationArea = all;
            }
            field("Amount Including VAT"; Rec."Amount Including VAT")
            {
                ApplicationArea = all;
            }
            field("Payment Term Remark"; Rec."Payment Term Remark")
            {
                ApplicationArea = all;
            }
            field(Remark; Rec.Remark)
            {
                ApplicationArea = all;
            }
            field("Customs Supervision"; Rec."Customs Supervision")
            {
                ApplicationArea = all;
            }
            field("Requested Delivery Date"; Rec."Requested Delivery Date")
            {
                ApplicationArea = all;
            }
            field("OC Date"; Rec."OC Date")
            {
                ApplicationArea = all;
            }
        }
        modify("Foreign Trade")
        {
            Visible = false;
        }
        modify(Prepayment)
        {
            Visible = false;
        }
        modify("Buy-from Vendor No.")
        {
            Importance = Promoted;
            ShowMandatory = true;
        }
        modify("Vendor Invoice No.")
        {
            ShowMandatory = false;
        }
        modify("Payment Terms Code")
        {
            Importance = Promoted;
            ShowMandatory = true;
        }
        modify("VAT Bus. Posting Group")
        {
            Importance = Promoted;
            ShowMandatory = true;
        }
        modify("Shortcut Dimension 1 Code")
        {
            Importance = Promoted;
            ShowMandatory = true;
        }
        modify("Purchaser Code")
        {
            Importance = Promoted;
            ShowMandatory = true;
        }
        movebefore("Requested Delivery Date"; "Expected Receipt Date")
        addafter("Purchaser Code")
        {
            field("Your Reference"; Rec."Your Reference")
            {
                ApplicationArea = all;
            }
        }

        addafter("Buy-from Vendor Name")
        {
            field("Buy-from Vendor Name 2"; Rec."Buy-from Vendor Name 2")
            {
                ApplicationArea = all;
            }
        }
        modify("Buy-from Vendor Name")
        {
            Visible = false;
        }

    }

    actions
    {
        modify("Create &Whse. Receipt")
        {
            Promoted = true;
            PromotedCategory = Process;
        }
        modify("Create Inventor&y Put-away/Pick")
        {
            Promoted = false;
        }

        addlast("F&unctions")
        {
            action("Import Purchase Line Komax")
            {
                Caption = 'Import Purchase Line Komax';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Buffer: Record "Excel Buffer" temporary;
                    Buffer2: Record "Excel Buffer" temporary;
                    ExcelUtil: Codeunit "TP Utilities";
                    InS: InStream;
                    Filename: Text;
                    Row: Integer;
                    LastRow: Integer;
                    ItemNo: Code[20];
                    ItemQuantity: Decimal;
                    UnitPrice: Decimal;
                    SalesLine: Record "Sales Line";
                    cha: Char;
                    GDocNo: Code[20];
                    GDocType: Option;
                    PurchaseLine: Record "Purchase Line";
                    PurchaseLine2: Record "Purchase Line";
                    No: Code[20];
                    Quantity: Decimal;

                    Window: Dialog;
                    LastLineNo: Integer;
                begin
                    if UploadIntoStream('Import Purchase Line Komax', '', '', Filename, InS) then begin
                        LastLineNo := 0;
                        Buffer.OpenBookStream(InS, 'Sheet1');
                        Buffer.ReadSheet();
                        Buffer.FindLast();
                        LastRow := Buffer."Row No.";
                        Buffer.Reset();

                        PurchaseLine2.RESET;
                        PurchaseLine2.SETCURRENTKEY("Document Type", "Document No.", "Line No.");
                        PurchaseLine2.SETRANGE("Document Type", GDocType);
                        PurchaseLine2.SETRANGE("Document No.", GDocNo);
                        IF PurchaseLine2.FIND('+') THEN
                            LastLineNo := PurchaseLine2."Line No.";

                        LastLineNo += 10000;

                        Window.open('Importing');
                        for row := 2 to LastRow do begin
                            No := ExcelUtil.GetCellText(Buffer, 1, Row);
                            Evaluate(Quantity, ExcelUtil.GetCellText(Buffer, 2, Row));

                            PurchaseLine.VALIDATE("Document Type", Rec."Document Type");
                            PurchaseLine.VALIDATE("Document No.", Rec."No.");
                            PurchaseLine.VALIDATE("Line No.", LastLineNo);
                            PurchaseLine.VALIDATE(Type, PurchaseLine.Type::Item);
                            PurchaseLine.VALIDATE("No.", No);
                            PurchaseLine.VALIDATE(Quantity, Quantity);
                            PurchaseLine.INSERT(TRUE);
                            LastLineNo += 10000;
                        end;
                        Window.Close();
                    end;
                end;
            }

            action("Machine No.")
            {
                Caption = 'Machine No.';
                Image = Text;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Lrcd_ReservationEntry: Record "Reservation Entry";
                    Lrcd_ProdOrderLine: Record "Prod. Order Line";
                    Lrcd_BOMVersion: Record "Production BOM Version";
                begin
                    Lrcd_ReservationEntry.RESET;
                    Lrcd_ReservationEntry.SETRANGE(Positive, TRUE);
                    Lrcd_ReservationEntry.SETRANGE(Lrcd_ReservationEntry."Source ID", Rec."No.");
                    IF Lrcd_ReservationEntry.FIND('-') THEN
                        REPEAT
                            Lrcd_ProdOrderLine.RESET;
                            Lrcd_ProdOrderLine.SETRANGE(Lrcd_ProdOrderLine."Prod. Order No.", Rec."No.");
                            Lrcd_ProdOrderLine.SETRANGE(Lrcd_ProdOrderLine."Line No.", Lrcd_ReservationEntry."Source Prod. Order Line");
                            Lrcd_ProdOrderLine.SETRANGE(Lrcd_ProdOrderLine."Item No.", Lrcd_ReservationEntry."Item No.");
                            IF Lrcd_ProdOrderLine.FIND('-') THEN BEGIN
                                Lrcd_ProdOrderLine."Machine No." := Lrcd_ReservationEntry."Serial No.";
                                Lrcd_ProdOrderLine.VALIDATE(Lrcd_ProdOrderLine."Machine No.", Lrcd_ReservationEntry."Serial No.");
                                Lrcd_ProdOrderLine.MODIFY;
                            END
                            ELSE BEGIN
                                Lrcd_ProdOrderLine."Machine No." := '';
                                Lrcd_ProdOrderLine.VALIDATE(Lrcd_ProdOrderLine."Machine No.", '');
                                Lrcd_ProdOrderLine.MODIFY;
                            END;
                        UNTIL Lrcd_ReservationEntry.NEXT = 0
                    ELSE BEGIN
                        Lrcd_ProdOrderLine.RESET;
                        Lrcd_ProdOrderLine.SETRANGE(Lrcd_ProdOrderLine."Prod. Order No.", Rec."No.");
                        Lrcd_ProdOrderLine.MODIFYALL(Lrcd_ProdOrderLine."Machine No.", '');
                    END;
                end;
            }

            // action("Refresh Ship-to")
            // {
            //     Caption = 'Refresh Ship-to';
            //     Image = Refresh;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;

            //     trigger OnAction()
            //     var
            //         PurchaseHeader: Record "Purchase Header";
            //         Location: Record Location;
            //     begin
            //         PurchaseHeader.Reset();
            //         PurchaseHeader.SetRange("Document Type", Rec."Document Type");
            //         if PurchaseHeader.FindFirst() then
            //             repeat
            //                 if (PurchaseHeader."Ship-to Code" = 'Location') and (PurchaseHeader."Location Code" <> '') then begin
            //                     if Location.get(PurchaseHeader."Location Code") then begin
            //                         PurchaseHeader."Location Name" := Location.Name;
            //                         PurchaseHeader."Ship-to Address" := Location.Address;
            //                         PurchaseHeader."Ship-to Address 2" := Location."Address 2";
            //                         PurchaseHeader."Ship-to City" := Location.City;
            //                         PurchaseHeader."Ship-to Post Code" := Location."Post Code";
            //                         PurchaseHeader.Modify();
            //                     end;
            //                 end;
            //             until PurchaseHeader.Next() = 0;
            //     end;
            // }
        }

        addafter("&Print")
        {
            action("Print Purchase Order In English")
            {
                Caption = 'Print Purchase Order In English';
                Image = Print;
                Promoted = true;
                PromotedCategory = Category10;

                trigger OnAction()
                var
                    ENPurchaseOrder: Report "EN Purchase Order";
                    PurchaseHeader: Record "Purchase Header";
                begin
                    Rec.TestField(Status, PurchaseHeader.Status::Released);
                    PurchaseHeader.SetRange("Document Type", Rec."Document Type"::Order);
                    PurchaseHeader.SetRange("No.", Rec."No.");
                    ENPurchaseOrder.SetTableView(PurchaseHeader);
                    ENPurchaseOrder.RunModal();
                end;
            }
            action("Print Purchase Order In Chinese")
            {
                Caption = 'Print Purchase Order In Chinese';
                Image = Print;
                Promoted = true;
                PromotedCategory = Category10;

                trigger OnAction()
                var
                    CNPurchaseOrder: Report "CN Purchase Order";
                    PurchaseHeader: Record "Purchase Header";
                begin
                    Rec.TestField(Status, PurchaseHeader.Status::Released);
                    PurchaseHeader.SetRange("Document Type", Rec."Document Type"::Order);
                    PurchaseHeader.SetRange("No.", Rec."No.");
                    CNPurchaseOrder.SetTableView(PurchaseHeader);
                    CNPurchaseOrder.RunModal();
                end;
            }
            action("Print Purchase Quote")
            {
                Caption = 'Print Purchase Quote';
                Image = Print;
                Promoted = true;
                PromotedCategory = Category10;

                trigger OnAction()
                var
                    PurchaseQuote: Report "Purchase Quote";
                    PurchaseHeader: Record "Purchase Header";
                begin
                    PurchaseHeader.SetRange("Document Type", Rec."Document Type"::Order);
                    PurchaseHeader.SetRange("No.", Rec."No.");
                    PurchaseQuote.SetTableView(PurchaseHeader);
                    PurchaseQuote.RunModal();
                end;
            }
        }


    }

    //-----------------------------------------------------------
    //#VOL1.00 - ALF - 2021/12/4
    //PO上增加： WorkDescription相关功能
    //------------------------------------------------------------ 
    trigger OnOpenPage()
    begin
        WorkDescription := Rec.GetWorkDescription;
    end;

    //-----------------------------------------------------------
    //#VOL1.00 - ALF - 2021/12/4
    //PO上增加： 计算TotalAmountToReceive字段
    //------------------------------------------------------------ 
    trigger OnAfterGetRecord()
    var
        PurchLine: Record "Purchase Line";
    begin
        TotalAmoutToReceive := 0;
        PurchLine.SETRANGE("Document Type", Rec."Document Type");
        PurchLine.SETRANGE("Document No.", Rec."No.");
        IF PurchLine.FINDFIRST THEN
            REPEAT
                TotalAmoutToReceive := TotalAmoutToReceive + PurchLine."Qty. to Receive" * PurchLine."Direct Unit Cost";
            UNTIL PurchLine.NEXT = 0;
    end;

    var
        TotalAmoutToReceive: Decimal;
        WorkDescription: Text;
        TPUtilities: Codeunit "TP Utilities";
}
