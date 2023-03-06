pageextension 59020 "TP Sales Order List" extends "Sales Order List"
{
    layout
    {
        // modify("External Document No.")
        // {
        //     Caption = 'External Document No.';
        // }
        // modify("Document Date")
        // {
        //     Caption = 'Order Date';
        // }
        modify(Status)
        {
            Visible = true;
        }
        modify("Payment Terms Code")
        {
            Visible = true;
        }
        modify("Posting Date")
        {
            Visible = true;
        }
        modify("Completely Shipped")
        {
            Visible = false;
        }
        modify("Amt. Ship. Not Inv. (LCY)")
        {
            Visible = false;
        }
        modify("Amt. Ship. Not Inv. (LCY) Base")
        {
            Visible = false;
        }
        modify("Salesperson Code")
        {
            Visible = true;
        }

        movefirst(Control1; "Document Date", "No.", "Sell-to Customer No.", "External Document No.", Amount, "Amount Including VAT", "Salesperson Code", "Location Code", "Payment Terms Code", Status, "Sell-to Customer Name", "Assigned User ID", "Posting Date")
        addafter("Sell-to Customer No.")
        {
            field("Sell-to Customer Name 2"; Rec."Sell-to Customer Name 2")
            {
                ApplicationArea = all;
            }
            field("Machine Model"; Rec."Machine Model")
            {
                ApplicationArea = all;
            }
        }
        modify("Currency Code")
        {
            Visible = true;
        }
        movebefore(Amount; "Currency Code")
        addafter(Amount)
        {
            field("Amount Excl VAT"; Rec."Amount Excl VAT")
            {
                ApplicationArea = all;
            }
            field("Advance Payment %"; Rec."Advance Payment %")
            { ApplicationArea = all; }
        }
        addafter("Amount Including VAT")
        {
            field("Outstanding Amount"; Rec."Outstanding Amount")
            {
                ApplicationArea = all;
            }
            field("Material Shipped not Invoiced"; Rec."Material Shipped not Invoiced")
            {
                ApplicationArea = all;
            }
        }
        addafter("Salesperson Code")
        {
            field("Order Type"; Rec."Order Type")
            {
                ApplicationArea = all;
            }
        }
        addafter(Status)
        {
            field("Partial Shipped"; Rec."Partial Shipped")
            {
                ApplicationArea = all;
            }
        }
        addbefore("No.")
        {
            field("Order Date"; Rec."Order Date")
            {
                ApplicationArea = all;
            }
        }
        addlast(Control1)
        {
            field("Completely Invoiced"; Rec."Completely Invoiced")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        addafter("&Order Confirmation")
        {

            group(Komax)
            {
                action("Batch Release")
                {
                    Caption = 'Batch Release';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ReleaseDoc: Codeunit "Release Sales Document";
                        SalesHeader: Record "Sales Header";
                        window: Dialog;
                    begin
                        UserSetup.Get(UserId);
                        UserSetup.TestField("Batch Rel. Or Del. Docs.");
                        If Not Confirm(Text002) then exit;
                        window.Open('Release#1###########');
                        CurrPage.SetSelectionFilter(SalesHeader);
                        if SalesHeader.FindFirst() then
                            repeat
                                window.Update(1, SalesHeader."No.");
                                ReleaseDoc.Run(SalesHeader);
                            until SalesHeader.Next() = 0;
                        window.Close();
                    end;
                }

                action("Refresh Completely Invoiced")
                {
                    Caption = 'Refresh Completely Invoiced';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        SalesLine: Record "Sales Line";
                        SalesHeader: Record "Sales Header";
                    begin
                        Window.open('#1##########');
                        SalesHeader.Reset();
                        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
                        SalesHeader.SetRange("Completely Invoiced", false);
                        if SalesHeader.FindFirst() then
                            repeat
                                Window.Update(1, SalesHeader."No.");
                                SalesLine.Reset();
                                SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                                SalesLine.SetRange("Document No.", SalesHeader."No.");
                                SalesLine.SetFilter(Quantity, '<>0');
                                if SalesLine.FindFirst() then begin
                                    SalesHeader."Completely Invoiced" := true;
                                    repeat
                                        if SalesLine.Quantity <> SalesLine."Quantity Invoiced" then begin
                                            SalesHeader."Completely Invoiced" := false;
                                        end;
                                    until SalesLine.Next() = 0;
                                end else begin
                                    SalesHeader."Completely Invoiced" := false;
                                end;
                                SalesHeader.Modify();
                            until SalesHeader.Next() = 0;
                        Window.Close();
                    end;
                }

                action("Batch Reopen")
                {
                    Caption = 'Batch Reopen';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ReleaseDoc: Codeunit "Release Sales Document";
                        SalesHeader: Record "Sales Header";
                        window: Dialog;
                    begin
                        UserSetup.Get(UserId);
                        UserSetup.TestField("Batch Rel. Or Del. Docs.");
                        If Not Confirm(Text002) then exit;
                        window.Open('Release#1###########');
                        CurrPage.SetSelectionFilter(SalesHeader);
                        if SalesHeader.FindFirst() then
                            repeat
                                window.Update(1, SalesHeader."No.");
                                ReleaseDoc.PerformManualReopen(SalesHeader);
                            until SalesHeader.Next() = 0;
                        window.Close();
                    end;
                }
                action("Shipped Not Invoiced")
                {
                    Caption = 'Shipped Not Invoiced';
                    Image = ListPage;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Shipped Not Invoiced";
                }

                // 期初导入未结订单
                //         Caption = 'Import';
                //         //#订单导入#
                //         action("Import Sales Order")
                //         {
                //             Caption = 'Import Sales Order';
                //             Image = Import;
                //             Promoted = true;
                //             PromotedCategory = Process;
                //             PromotedIsBig = true;
                //             ApplicationArea = all;
                //             trigger OnAction()
                //             var
                //                 Buffer: Record "Excel Buffer" temporary;
                //                 Buffer2: Record "Excel Buffer" temporary;
                //                 SalesHeader: Record "Sales Header";
                //                 Customer: Record Customer;
                //                 SalesLine: Record "Sales Line";
                //                 ExcelUtil: Codeunit "TP Utilities";
                //                 InS: InStream;
                //                 Filename: Text;
                //                 Row: Integer;
                //                 LastRow: Integer;
                //                 eOrderNo: Code[20];         //Column-A/1
                //                 eCustNo: Code[20];          //Column-B/2
                //                 eCustName: Text[100];        //Column-C/3
                //                 eOrderDate: date;           //Column-D/4
                //                 eSalesperson: Text[100];    //Column-E/5 
                //                 eLineNo: Integer;           //Column-F/6
                //                 eItemNo: Code[20];          //Column-G/7
                //                 // eItemDesc: text[100];       //Column-H/8
                //                 eLocation: Code[10];        //Column-H/8                
                //                 eQty: Decimal;              //Column-I/9  
                //                 eUOM: code[10];             //Column-J/10
                //                 eCurrCode: code[10];        //Column-K/11                   
                //                 ePrice: Decimal;            //Column-L/12
                //                 ePriceIncludingVat: Boolean;//Column-M/13
                //                 eVATRate: Decimal;          //Column-N/14
                //                 eCustOrderNo: Code[20];     //Column-O/15 
                //                 eOrderType: Enum "Sales Order Type";//Column-P/16
                //                 eMachineModule: Text[100];  //Column-Q/17
                //                 ePaymentTerms: Code[20];    //Column-R/18
                //                 eShippedQuantity: Decimal;  //Column-S/19
                //                 eSOHeadRemark: Text[100];   //Column-T/20
                //                 eSOLineRemark: Text[100];   //Column-U/21
                //                 eRequestedDeliveryDate: Date;//Column-V/22
                //                 eOutstandingQty: Decimal;   //Column-W/23
                //                 eQtyShippedNotInvoiced: Decimal;//Column-X/24
                //                 eUnitCostLCY: Decimal;      //Column-Y/25
                //                 eType: Enum "Sales Line Type";      //Column-Z/26

                //                 // eDept: code[20];             //Column-P/17
                //                 eDiscount: Decimal;
                //                 Window: Dialog;
                //                 LastLineNo: Integer;
                //                 Item: Record Item;
                //                 Blocked: Enum "Customer Blocked";
                //                 ItemBlocked: Boolean;
                //             begin
                //                 if UploadIntoStream('Import Sales Order', '', '', Filename, InS) then begin
                //                     LastLineNo := 0;
                //                     Buffer.OpenBookStream(InS, 'Sheet1');
                //                     Buffer.ReadSheet();
                //                     Buffer.FindLast();
                //                     LastRow := Buffer."Row No.";
                //                     Buffer.Reset();

                //                     Window.open('#1##########');
                //                     for row := 2 to LastRow do begin
                //                         eOrderNo := ExcelUtil.GetCellText(Buffer, 1, Row);
                //                         eCustNo := ExcelUtil.GetCellText(Buffer, 2, Row);
                //                         eCustName := ExcelUtil.GetCellText(Buffer, 3, Row);
                //                         Evaluate(eOrderDate, ExcelUtil.GetCellText(Buffer, 4, Row));
                //                         eSalesperson := ExcelUtil.GetCellText(Buffer, 5, Row);
                //                         Evaluate(eLineNo, ExcelUtil.GetCellText(Buffer, 6, Row));
                //                         eItemNo := ExcelUtil.GetCellText(Buffer, 7, Row);
                //                         eLocation := ExcelUtil.GetCellText(Buffer, 8, Row);
                //                         if (eLocation = 'SPAREPARTS') or (eLocation = 'PRODUCTION') then begin
                //                             eLocation := 'MAIN';
                //                         end;
                //                         if ExcelUtil.GetCellText(Buffer, 9, Row) = '' then begin
                //                             eQty := 0;
                //                         end else begin
                //                             Evaluate(eQty, ExcelUtil.GetCellText(Buffer, 9, Row));
                //                         end;
                //                         eUOM := ExcelUtil.GetCellText(Buffer, 10, Row);
                //                         eCurrCode := ExcelUtil.GetCellText(Buffer, 11, Row);
                //                         if ExcelUtil.GetCellText(Buffer, 12, Row) = '' then begin
                //                             ePrice := 0;
                //                         end else begin
                //                             Evaluate(ePrice, ExcelUtil.GetCellText(Buffer, 12, Row));
                //                         end;
                //                         Evaluate(ePriceIncludingVat, ExcelUtil.GetCellText(Buffer, 13, Row));
                //                         if ExcelUtil.GetCellText(Buffer, 14, Row) = '' then begin
                //                             eVATRate := 0;
                //                         end else begin
                //                             Evaluate(eVATRate, ExcelUtil.GetCellText(Buffer, 14, Row));
                //                         end;
                //                         eCustOrderNo := ExcelUtil.GetCellText(Buffer, 15, Row);
                //                         Evaluate(eOrderType, ExcelUtil.GetCellText(Buffer, 16, Row));
                //                         eMachineModule := ExcelUtil.GetCellText(Buffer, 17, Row);
                //                         ePaymentTerms := ExcelUtil.GetCellText(Buffer, 18, Row);
                //                         if ExcelUtil.GetCellText(Buffer, 19, Row) = '' then begin
                //                             eShippedQuantity := 0;
                //                         end else begin
                //                             Evaluate(eShippedQuantity, ExcelUtil.GetCellText(Buffer, 19, Row));
                //                         end;
                //                         eSOHeadRemark := ExcelUtil.GetCellText(Buffer, 20, Row);
                //                         eSOLineRemark := ExcelUtil.GetCellText(Buffer, 21, Row);
                //                         Evaluate(eRequestedDeliveryDate, ExcelUtil.GetCellText(Buffer, 22, Row));
                //                         if ExcelUtil.GetCellText(Buffer, 23, Row) = '' then begin
                //                             eOutstandingQty := 0;
                //                         end else begin
                //                             Evaluate(eOutstandingQty, ExcelUtil.GetCellText(Buffer, 23, Row));
                //                         end;
                //                         if ExcelUtil.GetCellText(Buffer, 24, Row) = '' then begin
                //                             eQtyShippedNotInvoiced := 0;
                //                         end else begin
                //                             Evaluate(eQtyShippedNotInvoiced, ExcelUtil.GetCellText(Buffer, 24, Row));
                //                         end;
                //                         if ExcelUtil.GetCellText(Buffer, 25, Row) = '' then begin
                //                             eUnitCostLCY := 0;
                //                         end else begin
                //                             Evaluate(eUnitCostLCY, ExcelUtil.GetCellText(Buffer, 25, Row));
                //                         end;
                //                         Evaluate(eType, ExcelUtil.GetCellText(Buffer, 26, Row));
                //                         Evaluate(eDiscount, ExcelUtil.GetCellText(Buffer, 30, Row));

                //                         if Customer.get(eCustNo) then begin
                //                             if Customer.Blocked <> Customer.Blocked::" " then begin
                //                                 Blocked := Customer.Blocked;
                //                                 Customer.Blocked := Customer.Blocked::" ";
                //                                 Customer.Modify();
                //                             end;
                //                         end;
                //                         if Item.get(eItemNo) then begin
                //                             if Item.Blocked = true then begin
                //                                 ItemBlocked := true;
                //                                 Item.Validate(Blocked, false);
                //                                 Item.Modify();
                //                             end else begin
                //                                 ItemBlocked := false;
                //                             end;
                //                         end;
                //                         Window.Update(1, eOrderNo);
                //                         //insert Material
                //                         if not SalesHeader.get(SalesHeader."Document Type"::Order, eOrderNo) then begin
                //                             SalesHeader.init;
                //                             SalesHeader."Document Type" := SalesHeader."Document Type"::Order;
                //                             SalesHeader.Status := SalesHeader.Status::Open;
                //                             SalesHeader."No." := eOrderNo;
                //                             SalesHeader.VALIDATE("Sell-to Customer No.", eCustNo);
                //                             SalesHeader.Validate("Document Date", eOrderDate);
                //                             SalesHeader.Validate("Order Date", eOrderDate);
                //                             // SalesHeader.Validate("Posting Date", eDeliverDate);
                //                             SalesHeader.Validate("Prices Including VAT", ePriceIncludingVat);
                //                             SalesHeader.LOCKTABLE;
                //                             SalesHeader.INSERT(TRUE);
                //                             // SalesHeader.Validate("Shortcut Dimension 1 Code", eDept); //维度1-部门
                //                             SalesHeader.Validate("Salesperson Code", eSalesperson);//业务员
                //                             SalesHeader.Validate("External Document No.", eCustOrderNo);//外部单据号
                //                             SalesHeader.Validate("Order Type", eOrderType);
                //                             SalesHeader.Validate("Machine Model", eMachineModule);
                //                             SalesHeader.Validate("Payment Terms Code", ePaymentTerms);
                //                             SalesHeader.Validate(Remark, eSOHeadRemark);
                //                             SalesHeader.Validate("Requested Delivery Date", eRequestedDeliveryDate);
                //                             SalesHeader.Validate("Currency Code", eCurrCode);
                //                             SalesHeader.Modify();
                //                             //SalesHeader."Sell-to Contact" := eCustContact;
                //                             //SalesHeader."Sell-to Phone No." := eCustPhone;
                //                         end else begin
                //                             SalesHeader."Document Date" := eOrderDate;
                //                             SalesHeader."Order Date" := eOrderDate;
                //                             // SalesHeader."Posting Date" := eDeliverDate;
                //                             // SalesHeader."Shortcut Dimension 1 Code" := eDept; //维度1-部门
                //                             SalesHeader."Salesperson Code" := eSalesperson; //业务员
                //                             SalesHeader."External Document No." := eCustOrderNo; //外部单据号
                //                             SalesHeader."Requested Delivery Date" := eRequestedDeliveryDate;
                //                             SalesHeader.Modify();
                //                         end;
                //                         if not SalesLine.get(SalesLine."Document Type"::Order, eOrderNo, eLineNo) then begin
                //                             SalesLine.INIT;
                //                             SalesLine."Document Type" := SalesLine."Document Type"::Order;
                //                             SalesLine."Document No." := eOrderNo;
                //                             SalesLine."Line No." := eLineNo;
                //                             SalesLine.VALIDATE("Type", eType);
                //                             Item.Get(eItemNo);
                //                             SalesLine.VALIDATE("No.", eItemNo);
                //                             SalesLine.Validate("Location Code", eLocation);
                //                             SalesLine.VALIDATE(Quantity, eQty);
                //                             SalesLine.validate("Currency Code", eCurrCode);
                //                             SalesLine.VALIDATE("Unit Price", ePrice);
                //                             SalesLine.validate("VAT %", eVATRate);
                //                             SalesLine.Validate(Remark, eSOLineRemark);
                //                             SalesLine.Validate("Requested Delivery Date", eRequestedDeliveryDate);
                //                             SalesLine.Validate("Unit Cost (LCY)", eUnitCostLCY);
                //                             if eQtyShippedNotInvoiced > 0 then
                //                                 SalesLine.Validate("Post Qty", eQtyShippedNotInvoiced);
                //                             SalesLine.Validate("Line Discount %", eDiscount);
                //                             SalesLine.INSERT(TRUE);
                //                         end else begin
                //                             SalesLine.Validate("Line Discount %", eDiscount);
                //                             SalesLine.Modify();
                //                         end;

                //                         if Customer.get(eCustNo) then begin
                //                             if Customer.Blocked <> Customer.Blocked::" " then begin
                //                                 Customer.Blocked := Blocked;
                //                                 Customer.Modify();
                //                             end;
                //                         end;
                //                         if Item.get(eItemNo) then begin
                //                             if ItemBlocked = true then begin
                //                                 Item.Validate(Blocked, true);
                //                                 Item.Modify();
                //                             end;
                //                         end;
                //                     end;
                //                     Window.Close();
                //                 end;
                //             end;
                //         }
            }
        }

        addafter("Print Confirmation")
        {
            action("Order Confirmation English")
            {
                Caption = 'Order Confirmation English';
                Image = Print;
                Promoted = true;
                PromotedCategory = Category8;

                trigger OnAction()
                var
                    ENSalesOrder: Report "EN Sales Order";
                    SalesHeader: Record "Sales Header";
                    SalesHeader2: Record "Sales Header";
                    DocFilter: Text;
                begin
                    Rec.TestField(Status, SalesHeader.Status::Released);
                    SalesHeader.Reset();
                    CurrPage.SetSelectionFilter(SalesHeader);
                    if SalesHeader.FindFirst() then
                        repeat
                            if DocFilter = '' then
                                DocFilter := SalesHeader."No."
                            else
                                DocFilter := DocFilter + '|' + SalesHeader."No.";
                        until SalesHeader.Next() = 0;
                    SalesHeader2.Reset();
                    SalesHeader2.setrange("Document Type", Rec."Document Type");
                    SalesHeader2.SetFilter("No.", DocFilter);
                    ENSalesOrder.SetTableView(SalesHeader2);
                    ENSalesOrder.RunModal();
                end;
            }
            action("Print Sales Order In Chinese")
            {
                Caption = 'Print Sales Order In Chinese';
                Image = Print;
                Promoted = true;
                PromotedCategory = Category8;

                trigger OnAction()
                var
                    CNSalesOrder: Report "CN Sales Order";
                    SalesHeader: Record "Sales Header";
                    SalesHeader2: Record "Sales Header";
                    DocFilter: Text;
                begin
                    Rec.TestField(Status, SalesHeader.Status::Released);
                    // Currpage.setselectionfilter(Salesheader);
                    // SalesHeader.SetRange("No.", Rec."No.");
                    // CNSalesOrder.Settableview(Salesheader);
                    // CNSalesOrder.Runmodal();

                    SalesHeader.Reset();
                    CurrPage.SetSelectionFilter(SalesHeader);
                    if SalesHeader.FindFirst() then
                        repeat
                            if DocFilter = '' then
                                DocFilter := SalesHeader."No."
                            else
                                DocFilter := DocFilter + '|' + SalesHeader."No.";
                        until SalesHeader.Next() = 0;
                    SalesHeader2.Reset();
                    SalesHeader2.setrange("Document Type", Rec."Document Type");
                    SalesHeader2.SetFilter("No.", DocFilter);
                    CNSalesOrder.SetTableView(SalesHeader2);
                    CNSalesOrder.RunModal();
                end;
            }

            action("Sales Shipment History")
            {
                Caption = 'Sales Shipment History';
                Image = Print;
                Promoted = true;
                PromotedCategory = Category8;

                trigger OnAction()
                var
                    SalesHistory: Report "Sales History";
                    SalesHeader: Record "Sales Header";
                    SalesShipmentLine2: Record "Sales Shipment Line";
                    DocFilter: Text;
                begin

                    SalesHeader.Reset();
                    CurrPage.SetSelectionFilter(SalesHeader);
                    if SalesHeader.FindFirst() then
                        repeat
                            if DocFilter = '' then
                                DocFilter := SalesHeader."No."
                            else
                                DocFilter := DocFilter + '|' + SalesHeader."No.";
                        until SalesHeader.Next() = 0;
                    SalesShipmentLine2.Reset();
                    // SalesHeader2.setrange("Document Type", Rec."Document Type");
                    SalesShipmentLine2.SetFilter("Order No.", DocFilter);
                    SalesHistory.SetTableView(SalesShipmentLine2);
                    SalesHistory.RunModal();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        SalesLIne: Record "Sales Line";
    begin
        TotalQuantity := 0;
        SalesLIne.Reset();
        SalesLIne.SetRange("Document Type", Rec."Document Type");
        SalesLIne.SetRange("Document No.", Rec."No.");
        if SalesLIne.FindFirst() then begin
            repeat
                TotalQuantity := TotalQuantity + SalesLIne.Quantity;
            until SalesLIne.Next() = 0;
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
        TotalQuantity: Decimal;
        Text002: Label 'Will you confirm?';
        userSetup: Record "User Setup";
        Window: Dialog;
}
