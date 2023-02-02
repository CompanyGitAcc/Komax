pageextension 59044 "TP Purchase Order List" extends "Purchase Order List"
{
    //------------------------------------------------------------
    //#VOL1.00 - ALF - 2021/11/25
    //增加字段：Project No./Name
    //------------------------------------------------------------       
    layout
    {
        addafter("Purchaser Code")
        {
            field("Order Type"; rec."Order Type")
            {
                ApplicationArea = all;
            }
        }
        addlast(Control1)
        {
            field("Total Quantity"; TotalQuantity)
            {
                ApplicationArea = Basic, Suite;
                AutoFormatType = 1;
                Caption = 'Total Quantity';
                Editable = false;
            }
            field("Completely Received"; Rec."Completely Received")
            {
                ApplicationArea = all;
            }
            field("Customs Supervision"; Rec."Customs Supervision")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
        }
    }

    actions
    {
        addafter("O&rder")
        {
            group(Import)
            {
                Caption = 'Import';
                action("Import Purch. Order")
                {
                    Caption = 'Import Purchase Order';
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ApplicationArea = all;
                    trigger OnAction()
                    var
                        Buffer: Record "Excel Buffer" temporary;
                        Buffer2: Record "Excel Buffer" temporary;
                        PurchHeader: Record "Purchase Header";
                        PurchLine: Record "Purchase Line";
                        ExcelUtil: Codeunit "TP Utilities";
                        InS: InStream;
                        Filename: Text;
                        Row: Integer;
                        LastRow: Integer;
                        eOrderNo: Code[20];         //Column-A/1
                        eVendorNo: Code[20];          //Column-B/2
                        eVendorName: Text[100];        //Column-C/3
                        eOrderDate: date;           //Column-D/4
                        ePurchaser: Text[100];    //Column-E/5 
                        eLineNo: Integer;           //Column-F/6
                        eItemNo: Code[20];          //Column-G/7
                        eItemDesc: text[100];       //Column-H/8
                        eDeliverDate: date;         //Column-I/9  
                        eLocation: Code[10];        //Column-J/10                                            
                        eQty: Decimal;              //Column-K/11
                        eUOM: code[10];             //Column-L/12
                        eCurrCode: code[10];        //Column-M/13                    
                        ePrice: Decimal;            //Column-N/14
                        ePriceIncludingVat: Boolean;//Column-O/15
                        eVATRate: Decimal;          //Column-P/16 
                        eDept: Code[20];            //Column-Q/17 
                        eOutstandingQty: Decimal;    //Column-R/18
                        eQtyRcdNotInvoiced: Decimal; //Column-S/19
                        eType: Enum "Purchase Line Type";//Column-T/20
                        // ePreparedBy: Text[100];      //Column-E/17

                        Window: Dialog;
                        LastLineNo: Integer;
                        Item: Record "Item";
                        ItemBlocked: Boolean;
                        Vendor: Record Vendor;
                        Blocked: Enum "Vendor Blocked";
                    begin
                        if UploadIntoStream('Import Purchase Order', '', '', Filename, InS) then begin
                            LastLineNo := 0;
                            Buffer.OpenBookStream(InS, 'Sheet1');
                            Buffer.ReadSheet();
                            Buffer.FindLast();
                            LastRow := Buffer."Row No.";
                            Buffer.Reset();

                            Window.open('#1##########');
                            for row := 2 to LastRow do begin
                                eOrderNo := ExcelUtil.GetCellText(Buffer, 1, Row);
                                eVendorNo := ExcelUtil.GetCellText(Buffer, 2, Row);
                                eVendorName := ExcelUtil.GetCellText(Buffer, 3, Row);
                                Evaluate(eOrderDate, ExcelUtil.GetCellText(Buffer, 4, Row));
                                // eOrderDate := ConvertDate(ExcelUtil.GetCellText(Buffer, 4, Row));
                                ePurchaser := ExcelUtil.GetCellText(Buffer, 5, Row);
                                Evaluate(eLineNo, ExcelUtil.GetCellText(Buffer, 6, Row));
                                eItemNo := ExcelUtil.GetCellText(Buffer, 7, Row);
                                eItemDesc := ExcelUtil.GetCellText(Buffer, 8, Row);
                                Evaluate(eDeliverDate, ExcelUtil.GetCellText(Buffer, 9, Row));
                                // eDeliverDate := ConvertDate(ExcelUtil.GetCellText(Buffer, 9, Row));
                                eLocation := ExcelUtil.GetCellText(Buffer, 10, Row);
                                if (eLocation = 'SPAREPARTS') or (eLocation = 'PRODUCTION') then begin
                                    eLocation := 'MAIN';
                                end;
                                Evaluate(eQty, ExcelUtil.GetCellText(Buffer, 11, Row));
                                eUOM := ExcelUtil.GetCellText(Buffer, 12, Row);
                                eCurrCode := ExcelUtil.GetCellText(Buffer, 13, Row);
                                Evaluate(ePrice, ExcelUtil.GetCellText(Buffer, 14, Row));
                                Evaluate(ePriceIncludingVat, ExcelUtil.GetCellText(Buffer, 15, Row));
                                Evaluate(eVATRate, ExcelUtil.GetCellText(Buffer, 16, Row));
                                eDept := ExcelUtil.GetCellText(Buffer, 17, Row);
                                Evaluate(eOutstandingQty, ExcelUtil.GetCellText(Buffer, 18, Row));
                                Evaluate(eQtyRcdNotInvoiced, ExcelUtil.GetCellText(Buffer, 19, Row));
                                Evaluate(eType, ExcelUtil.GetCellText(Buffer, 20, Row));
                                // ePreparedBy := ExcelUtil.GetCellText(Buffer, 17, Row);

                                if Vendor.get(eVendorNo) then begin
                                    if Vendor.Blocked <> Vendor.Blocked::" " then begin
                                        Blocked := Vendor.Blocked;
                                        Vendor.Blocked := Vendor.Blocked::" ";
                                        Vendor.Modify();
                                    end;
                                end;
                                if Item.get(eItemNo) then begin
                                    if Item.Blocked = true then begin
                                        ItemBlocked := true;
                                        Item.Validate(Blocked, false);
                                        Item.Modify();
                                    end else begin
                                        ItemBlocked := false;
                                    end;
                                end;
                                //insert Material
                                if not PurchHeader.get(PurchHeader."Document Type"::Order, eOrderNo) then begin
                                    PurchHeader.init;
                                    PurchHeader."Document Type" := PurchHeader."Document Type"::Order;
                                    PurchHeader.Status := PurchHeader.Status::Open;
                                    PurchHeader."No." := eOrderNo;
                                    PurchHeader.VALIDATE("Buy-from Vendor No.", eVendorNo);
                                    PurchHeader.Validate("Currency Code", eCurrCode);
                                    PurchHeader.Validate("Document Date", eOrderDate);
                                    PurchHeader.Validate("Order Date", eOrderDate);
                                    if ExcelUtil.GetCellText(Buffer, 9, Row) <> '' then begin
                                        PurchHeader.Validate("Posting Date", eDeliverDate);
                                    end;
                                    PurchHeader.LOCKTABLE;
                                    PurchHeader.INSERT(TRUE);
                                    PurchHeader.Validate("Shortcut Dimension 1 Code", eDept); //维度1-部门
                                    PurchHeader.Validate("Purchaser Code", ePurchaser); //业务员
                                    //PurchHeader.Validate("Prepared By", ePreparedBy); //制单人
                                    PurchHeader.Validate("Prices Including VAT", ePriceIncludingVat);
                                    PurchHeader.Modify();
                                end else begin
                                    PurchHeader."Document Date" := eOrderDate;
                                    PurchHeader."Order Date" := eOrderDate;
                                    PurchHeader."Posting Date" := eDeliverDate;
                                    PurchHeader."Shortcut Dimension 1 Code" := eDept; //维度1-部门
                                    PurchHeader."Purchaser Code" := ePurchaser; //业务员
                                    //PurchHeader."Prepared By" := ePreparedBy; //制单人
                                    PurchHeader.Modify();
                                end;

                                if not PurchLine.get(PurchLine."Document Type"::Order, eOrderNo, eLineNo) then begin
                                    PurchLine.INIT;
                                    PurchLine."Document Type" := PurchLine."Document Type"::Order;
                                    PurchLine."Document No." := eOrderNo;
                                    PurchLine."Line No." := eLineNo;
                                    // PurchLine.VALIDATE(Type, PurchLine.Type::Item);
                                    PurchLine.VALIDATE(Type, eType);
                                    PurchLine.VALIDATE("No.", eItemNo);
                                    PurchLine.Validate("Location Code", eLocation);
                                    PurchLine.VALIDATE(Quantity, eQty);
                                    PurchLine.validate("Currency Code", eCurrCode);
                                    PurchLine.VALIDATE("Direct Unit Cost", ePrice);
                                    PurchLine.validate("VAT %", eVATRate);
                                    PurchLine.validate("Expected Receipt Date", eDeliverDate);
                                    PurchLine.Validate("Outstanding Quantity", eOutstandingQty);
                                    PurchLine.Validate("Qty. Rcd. Not Invoiced", eQtyRcdNotInvoiced);
                                    PurchLine.INSERT(TRUE);
                                end else begin
                                    PurchLine.Validate("Shortcut Dimension 1 Code", eDept);
                                    PurchLine."Order Date" := eOrderDate;
                                    PurchLine.Modify();
                                end;
                                if Vendor.get(eVendorNo) then begin
                                    if Vendor.Blocked <> Vendor.Blocked::" " then begin
                                        Vendor.Blocked := Blocked;
                                        Vendor.Modify();
                                    end;
                                end;
                                if Item.get(eItemNo) then begin
                                    if ItemBlocked = true then begin
                                        Item.Validate(Blocked, true);
                                        Item.Modify();
                                    end;
                                end;
                            end;
                        end;
                    end;
                }
            }
        }

        addafter(Print)
        {
            action("Print Purchase Order In English")
            {
                Caption = 'Print Purchase Order In English';
                Image = Print;
                Promoted = true;
                PromotedCategory = Category5;

                trigger OnAction()
                var
                    ENPurchaseOrder: Report "EN Purchase Order";
                    PurchaseHeader: Record "Purchase Header";
                    PurchaseHeader2: Record "Purchase Header";
                    DocFilter: Text;
                begin
                    // PurchaseHeader.SetRange("Document Type", Rec."Document Type"::Order);
                    // PurchaseHeader.SetRange("No.", Rec."No.");
                    // ENPurchaseOrder.SetTableView(PurchaseHeader);
                    // ENPurchaseOrder.RunModal();

                    PurchaseHeader.Reset();
                    CurrPage.SetSelectionFilter(PurchaseHeader);
                    if PurchaseHeader.FindFirst() then
                        repeat
                            if DocFilter = '' then
                                DocFilter := PurchaseHeader."No."
                            else
                                DocFilter := DocFilter + '|' + PurchaseHeader."No.";
                        until PurchaseHeader.Next() = 0;
                    PurchaseHeader2.Reset();
                    PurchaseHeader2.setrange("Document Type", Rec."Document Type");
                    PurchaseHeader2.SetFilter("No.", DocFilter);
                    ENPurchaseOrder.SetTableView(PurchaseHeader2);
                    ENPurchaseOrder.RunModal();
                end;
            }
            action("Print Purchase Order In Chinese")
            {
                Caption = 'Print Purchase Order In Chinese';
                Image = Print;
                Promoted = true;
                PromotedCategory = Category5;

                trigger OnAction()
                var
                    CNPurchaseOrder: Report "CN Purchase Order";
                    PurchaseHeader: Record "Purchase Header";
                    PurchaseHeader2: Record "Purchase Header";
                    DocFilter: Text;
                begin
                    // PurchaseHeader.SetRange("Document Type", Rec."Document Type"::Order);
                    // PurchaseHeader.SetRange("No.", Rec."No.");
                    // CNPurchaseOrder.SetTableView(PurchaseHeader);
                    // CNPurchaseOrder.RunModal();

                    PurchaseHeader.Reset();
                    CurrPage.SetSelectionFilter(PurchaseHeader);
                    if PurchaseHeader.FindFirst() then
                        repeat
                            if DocFilter = '' then
                                DocFilter := PurchaseHeader."No."
                            else
                                DocFilter := DocFilter + '|' + PurchaseHeader."No.";
                        until PurchaseHeader.Next() = 0;
                    PurchaseHeader2.Reset();
                    PurchaseHeader2.setrange("Document Type", Rec."Document Type");
                    PurchaseHeader2.SetFilter("No.", DocFilter);
                    CNPurchaseOrder.SetTableView(PurchaseHeader2);
                    CNPurchaseOrder.RunModal();
                end;
            }
            action("Print Purchase Quote")
            {
                Caption = 'Print Purchase Quote';
                Image = Print;
                Promoted = true;
                PromotedCategory = Category5;

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
            action("Batch Release")
            {
                Caption = 'Batch Release';
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ReleaseDoc: Codeunit "Release Purchase Document";
                    PurchHeader: Record "Purchase Header";
                    window: Dialog;
                begin
                    UserSetup.Get(UserId);
                    UserSetup.TestField("Batch Rel. Or Del. Docs.");
                    If Not Confirm(Text002) then exit;
                    window.Open('Release#1###########');
                    CurrPage.SetSelectionFilter(PurchHeader);
                    if PurchHeader.FindFirst() then
                        repeat
                            window.Update(1, PurchHeader."No.");
                            ReleaseDoc.Run(PurchHeader);
                        until PurchHeader.Next() = 0;
                    window.Close();
                end;
            }
            action("Batch Delete")
            {
                Caption = 'Batch Delete';
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    PurchHeader: Record "Purchase Header";
                    window: Dialog;
                begin
                    UserSetup.Get(UserId);
                    UserSetup.TestField("Batch Rel. Or Del. Docs.");
                    If Not Confirm(Text002) then exit;
                    window.Open('Delete#1###########');
                    CurrPage.SetSelectionFilter(PurchHeader);
                    if PurchHeader.FindFirst() then
                        repeat
                            window.Update(1, PurchHeader."No.");
                            PurchHeader.Delete(true);
                        until PurchHeader.Next() = 0;
                    window.Close();
                end;
            }
            action("Refresh Item Reference")
            {
                Caption = 'Refresh Item Reference';
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    PurchLine: Record "Purchase Line";
                    ItemReference: Record "Item Reference";
                    window: Dialog;
                begin
                    window.Open('#1################');
                    PurchLine.Reset();
                    PurchLine.SetRange("Item Reference No.", '');
                    if PurchLine.FindFirst() then
                        repeat
                            window.Update(1, PurchLine."Document No.");
                            ItemReference.Reset();
                            ItemReference.SetRange("Item No.", PurchLine."No.");
                            ItemReference.SetRange("Reference Type", ItemReference."Reference Type"::Vendor);
                            ItemReference.SetRange("Reference Type No.", PurchLine."Buy-from Vendor No.");
                            if ItemReference.FindFirst() then begin
                                PurchLine."Item Reference No." := ItemReference."Reference No.";
                                PurchLine."Item Reference Type" := PurchLine."Item Reference Type"::Vendor;
                                PurchLine."Item Reference Type No." := ItemReference."Reference Type No.";
                                PurchLine."Item Reference Unit of Measure" := ItemReference."Unit of Measure";
                                PurchLine.Modify();
                            end;
                        until PurchLine.Next() = 0;
                    window.Close();
                end;
            }
            // action("Refresh Line Dimen")
            // {
            //     Caption = 'Refresh Line Dimension';
            //     Image = Refresh;

            //     trigger OnAction()
            //     var
            //         PurchHeader: Record "Purchase Header";
            //         PurchLine: Record "Purchase Line";
            //     begin
            //         PurchLine.Reset();
            //         If PurchLine.FindFirst() then
            //             repeat
            //                 if PurchHeader.get(PurchLine."Document Type", PurchLine."Document No.") then begin
            //                     if PurchHeader."Shortcut Dimension 1 Code" <> '' then begin
            //                         PurchLine.Validate("Shortcut Dimension 1 Code", PurchHeader."Shortcut Dimension 1 Code");
            //                         PurchLine.Modify();
            //                     end;
            //                 end;
            //             until PurchLine.Next() = 0;
            //     end;
            // }


            // action("Update Ship-to Code")
            // {
            //     Caption = 'Update Ship-to Code';
            //     Image = Refresh;

            //     trigger OnAction()
            //     var
            //         PurchHeader: Record "Purchase Header";
            //         PurchLine: Record "Purchase Line";
            //         ReleasePO: Codeunit "Release Purchase Document";
            //     begin
            //         PurchHeader.Reset();
            //         PurchHeader.SetRange("Document Type", PurchHeader."Document Type"::Order);
            //         If PurchHeader.FindFirst() then
            //             repeat
            //                 PurchLine.Reset();
            //                 PurchLine.SetRange(Type, PurchLine.Type::Item);
            //                 PurchLine.SetRange("Document No.", PurchHeader."No.");
            //                 if PurchLine.FindFirst() then begin
            //                     if PurchHeader.Status = PurchHeader.Status::Open then begin
            //                         PurchHeader.Validate("Location Code", PurchLine."Location Code");
            //                         PurchHeader.Modify();
            //                     end;
            //                     if PurchHeader.Status = PurchHeader.Status::Released then begin
            //                         ReleasePO.Reopen(PurchHeader);
            //                         PurchHeader.Validate("Location Code", PurchLine."Location Code");
            //                         PurchHeader.Modify();
            //                         ReleasePO.Run(PurchHeader);
            //                         PurchHeader.Modify();
            //                     end;

            //                 end;
            //             until PurchHeader.Next() = 0;
            //     end;
            // }

        }
    }
    trigger OnAfterGetRecord()
    var
        PurchaseLIne: Record "Purchase Line";
    begin
        TotalQuantity := 0;
        PurchaseLIne.Reset();
        PurchaseLIne.SetRange("Document Type", Rec."Document Type");
        PurchaseLIne.SetRange("Document No.", Rec."No.");
        if PurchaseLIne.FindFirst() then begin
            repeat
                TotalQuantity := TotalQuantity + PurchaseLIne.Quantity;
            until PurchaseLIne.Next() = 0;
        end else
            TotalQuantity := 0;
    end;


    procedure ConvertDate(DateText: Text[20]): date
    var
        YearL: Integer;
        MonthL: Integer;
        DayL: Integer;
    begin
        if StrPos(DateText, '/') <> 0 then begin
            Evaluate(DayL, CopyStr(DateText, 4, 2));
            Evaluate(MonthL, CopyStr(DateText, 1, 2));
            Evaluate(YearL, CopyStr(DateText, 7, 2));
            exit(DMY2Date(DayL, MonthL, 2000 + YearL));
        end;

    end;


    var
        Text002: Label 'Will you confirm?';
        TotalQuantity: Decimal;
        UserSetup: Record "User Setup";
}
