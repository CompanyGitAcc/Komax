codeunit 50012 "TP Events Handler"
{
    Permissions = tabledata "Sales Invoice Header" = rmd,
    tabledata "Sales Cr.Memo Header" = rmd,
    tabledata "Purch. Inv. Header" = rmd,
    tabledata "G/L Entry" = rmd,
    tabledata "Purch. Cr. Memo Hdr." = rmd;

    //==================================================================================================
    //BC190.Deposit1.00.ALF.22/11/20
    //过账Deposit的时候将销售订单号过账到Entry表中
    //==================================================================================================
    [EventSubscriber(ObjectType::Codeunit, 12, 'OnBeforeCustLedgEntryInsert', '', false, false)]
    procedure DepositToCustEntry(VAR CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    var
        WhseSetup: Record "Warehouse Setup";
    begin
        CustLedgerEntry."Order No." := GenJournalLine."Order No.";
        CustLedgerEntry."Advance Payment" := GenJournalLine."Advance Payment";
    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnBeforeVendLedgEntryInsert', '', false, false)]
    procedure DepositToVendEntry(VAR VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    var
        WhseSetup: Record "Warehouse Setup";
    begin
        VendorLedgerEntry."Order No." := GenJournalLine."Order No.";
        VendorLedgerEntry."Advance Payment" := GenJournalLine."Advance Payment";
    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnBeforeInsertDtldCustLedgEntry', '', false, false)]
    procedure DepositToDtlCustEntry(VAR DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry"; GenJournalLine: Record "Gen. Journal Line"; DtldCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer")
    var
        WhseSetup: Record "Warehouse Setup";
    begin
        DtldCustLedgEntry."Order No." := GenJournalLine."Order No.";
        DtldCustLedgEntry."Advance Payment" := GenJournalLine."Advance Payment";
    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnBeforeInsertDtldVendLedgEntry', '', false, false)]
    procedure DepositToDtlVendEntry(VAR DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry"; GenJournalLine: Record "Gen. Journal Line"; DtldCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer")
    var
        WhseSetup: Record "Warehouse Setup";
    begin
        DtldVendLedgEntry."Order No." := GenJournalLine."Order No.";
        DtldVendLedgEntry."Advance Payment" := GenJournalLine."Advance Payment";
    end;

    //==================================================================================================
    //BC190.Deposit1.00.ALF.22/11/20
    //销售订单创建发货单的时候检查Deposit
    //==================================================================================================
    [EventSubscriber(ObjectType::Codeunit, 5752, 'OnBeforeCreateFromSalesOrder', '', false, false)]
    procedure VerifyAdvancePayment(var SalesHeader: Record "Sales Header")
    var
        RequiredAmount: Decimal;
        Err01: Label 'Received Advance Payment amount cannot be less than %1';
    begin
        if SalesHeader."Document Type" <> SalesHeader."Document Type"::Order then
            exit;

        if SalesHeader."Advance Payment %" > 0 then begin
            SalesHeader.CalcFields("Advance Payment Received", "Amount Including VAT");
            RequiredAmount := SalesHeader."Advance Payment %" * SalesHeader."Amount Including VAT" / 100;
            if (SalesHeader."Advance Payment Received" < RequiredAmount) then
                Error(Err01, RequiredAmount);
        end;
    end;

    //==================================================================================================
    //仓库收货或发货单，如果部分过账，允许过账后删除
    //==================================================================================================
    [EventSubscriber(ObjectType::Codeunit, 5760, 'OnAfterPostUpdateWhseDocuments', '', false, false)]
    procedure OnAfterPostUpdateWhseRcpt(VAR WarehouseReceiptHeader: Record "Warehouse Receipt Header"; VAR WhsePutAwayRequest: Record "Whse. Put-away Request")
    var
        WhseSetup: Record "Warehouse Setup";
    begin
        if WhseSetup.Get() then
            if WhseSetup."Delete Partial Whse. Rcpt." then
                if WarehouseReceiptHeader.Delete(true) then;
    end;

    [EventSubscriber(ObjectType::Codeunit, 5763, 'OnAfterPostUpdateWhseDocuments', '', false, false)]
    procedure OnAfterPostUpdateWhseShpt(VAR WhseShptHeader: Record "Warehouse Shipment Header")
    var
        WhseSetup: Record "Warehouse Setup";
    begin
        if WhseSetup.Get() then
            if WhseSetup."Delete Partial Whse. Shpt." then begin
                WhseShptHeader.Status := WhseShptHeader.Status::Open;
                if WhseShptHeader.Delete(true) then;
            end;

    end;

    //==================================================================================================
    //++Harvey:仓库发货单过账到已过账销售发货单更新“Ship-to Phone No.”信息
    //==================================================================================================
    // [EventSubscriber(ObjectType::Codeunit, 5763, 'OnPostSourceDocumentOnBeforePrintSalesShipment', '', false, false)]
    // procedure WarehouseShptPosttoPostedSalesShpt(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean; var SalesShptHeader: Record "Sales Shipment Header"; WhseShptHeader: Record "Warehouse Shipment Header")
    // begin
    //     SalesShptHeader.Remark := WhseShptHeader.Remark;
    //     SalesShptHeader.Modify();
    // end;

    [EventSubscriber(ObjectType::Codeunit, 80, 'OnAfterSalesShptHeaderInsert', '', false, false)]
    procedure OnAfterSalesShptHeaderInsert(var SalesShipmentHeader: Record "Sales Shipment Header"; SalesHeader: Record "Sales Header"; SuppressCommit: Boolean; WhseShip: Boolean; WhseReceive: Boolean; var TempWhseShptHeader: Record "Warehouse Shipment Header"; var TempWhseRcptHeader: Record "Warehouse Receipt Header")
    begin
        // SalesShipmentHeader."Ship-to Phone No." := TempWhseShptHeader."Ship-to Phone No.";
        // SalesShipmentHeader.Remark := TempWhseShptHeader.Remark;
        // SalesShipmentHeader.Modify();
    end;

    //==================================================================================================
    //++YK002-HH:采购订单转仓库发货单的时候更新“备注”信息
    //==================================================================================================
    [EventSubscriber(ObjectType::Report, 5753, 'OnPurchaseLineOnAfterCreateShptHeader', '', false, false)]
    procedure CopyShiptoAdd1(var WhseShptHeader: Record "Warehouse Shipment Header"; WhseHeaderCreated: Boolean; PurchaseHeader: Record "Purchase Header"; PurchaseLine: Record "Purchase Line"; WarehouseRequest: Record "Warehouse Request");
    var
        WarehouseReq: Record "Warehouse Request";
        warehouseSetup: Record "Warehouse Setup";
    begin
        // WhseShptHeader.Validate("Ship-to Type", WhseShptHeader."Ship-to Type"::Vendor);
        // WhseShptHeader.validate("Ship-to No.", PurchaseHeader."Buy-from Vendor No.");
        // WhseShptHeader.validate("Ship-to Address Code", PurchaseHeader."Order Address Code");
        WhseShptHeader.Validate(Remark, PurchaseHeader.Remark);

        WhseShptHeader.Modify();
    end;


    //==================================================================================================
    //++: Codeunit 5750 "Whse.-Create Source Document"
    //++YK002-HH:SalesLine转Warehouse Shipment Line的额时候默认Bin Code
    //==================================================================================================

    [EventSubscriber(ObjectType::codeunit, 5750, 'OnAfterCreateShptLineFromSalesLine', '', false, false)]
    procedure DefaultBinCodeShptLine(var WarehouseShipmentLine: Record "Warehouse Shipment Line"; WarehouseShipmentHeader: Record "Warehouse Shipment Header"; SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header");
    var
        Item: Record Item;
        BinContent: Record "Bin Content";
        WarehouseReq: Record "Warehouse Request";
        warehouseSetup: Record "Warehouse Setup";
    begin
        //IF WarehouseShipmentLine."Bin Code" = '' then begin
        IF Item.Get(WarehouseShipmentLine."Item No.") then begin
            BinContent.Reset();
            BinContent.SetRange("Item No.", Item."No.");
            BinContent.SetRange("Location Code", WarehouseShipmentLine."Location Code");
            BinContent.SetRange(Default, true);
            if BinContent.FindFirst() then
                WarehouseShipmentLine."Bin Code" := BinContent."Bin Code";
        end;

        //Warehouse Ship-to
        // SalesHeader.get(SalesLine."Document Type", SalesLine."Document No.");
        // WarehouseShipmentHeader.Validate("Ship-to Type", WarehouseShipmentHeader."Ship-to Type"::Customer);
        // WarehouseShipmentHeader.Validate("Ship-to No.", SalesHeader."Sell-to Customer No.");
        // WarehouseShipmentHeader.Validate("Ship-to Address Code", SalesHeader."Ship-to Code");
        // WarehouseShipmentHeader.Modify();
    end;
    //采购退货
    [EventSubscriber(ObjectType::codeunit, 5750, 'OnAfterCreateShptLineFromPurchLine', '', false, false)]
    procedure DefaultBinCodeShptLine2(var WarehouseShipmentLine: Record "Warehouse Shipment Line"; WarehouseShipmentHeader: Record "Warehouse Shipment Header"; PurchaseLine: Record "Purchase Line");
    var
        Item: Record Item;
        BinContent: Record "Bin Content";
        WarehouseReq: Record "Warehouse Request";
        warehouseSetup: Record "Warehouse Setup";
        PurchaseHeader: Record "Purchase Header";
    begin
        IF Item.Get(WarehouseShipmentLine."Item No.") then begin
            BinContent.Reset();
            BinContent.SetRange("Item No.", Item."No.");
            BinContent.SetRange("Location Code", WarehouseShipmentLine."Location Code");
            BinContent.SetRange(Default, true);
            if BinContent.FindFirst() then
                WarehouseShipmentLine."Bin Code" := BinContent."Bin Code";
        end;

        // WarehouseShipmentHeader.Validate("Ship-to Type", WarehouseShipmentHeader."Ship-to Type"::Vendor);
        // WarehouseShipmentHeader.validate("Ship-to No.", PurchaseHeader."Buy-from Vendor No.");
        // WarehouseShipmentHeader.validate("Ship-to Address Code", PurchaseHeader."Order Address Code");

        // WarehouseShipmentHeader.Modify();

    end;
    //采购单
    [EventSubscriber(ObjectType::codeunit, 5750, 'OnAfterCreateRcptLineFromPurchLine', '', false, false)]
    procedure DefaultBinCodeRcptLine(var WarehouseReceiptLine: Record "Warehouse Receipt Line"; WarehouseReceiptHeader: Record "Warehouse Receipt Header"; PurchaseLine: Record "Purchase Line");
    var
        Item: Record Item;
        BinContent: Record "Bin Content";
        WarehouseReq: Record "Warehouse Request";
        WarehouseSetup: Record "Warehouse Setup";
        PurchaseHeader: Record "Purchase Header";
    begin
        //IF WarehouseShipmentLine."Bin Code" = '' then begin
        IF Item.Get(WarehouseReceiptLine."Item No.") then begin
            BinContent.Reset();
            BinContent.SetRange("Item No.", Item."No.");
            BinContent.SetRange("Location Code", WarehouseReceiptLine."Location Code");
            BinContent.SetRange(Default, true);
            if BinContent.FindFirst() then
                WarehouseReceiptLine."Bin Code" := BinContent."Bin Code";
        end;
        //end;
        // PurchaseHeader.get(PurchaseLine."Document Type", PurchaseLine."Document No.");
        // WarehouseReceiptHeader.Validate("Buy-from Type", WarehouseReceiptHeader."Buy-from Type"::Vendor);
        // WarehouseReceiptHeader.Validate("Buy-from No.", PurchaseHeader."Buy-from Vendor No.");

        // WarehouseReceiptHeader.Modify();

    end;
    //销售退货单
    [EventSubscriber(ObjectType::codeunit, 5750, 'OnAfterCreateRcptLineFromSalesLine', '', false, false)]
    procedure DefaultBinCodeRcptLine2(var WarehouseReceiptLine: Record "Warehouse Receipt Line"; WarehouseReceiptHeader: Record "Warehouse Receipt Header"; SalesLine: Record "Sales Line");
    var
        Item: Record Item;
        BinContent: Record "Bin Content";
        WarehouseReq: Record "Warehouse Request";
        WarehouseSetup: Record "Warehouse Setup";
        SalesHeader: Record "Sales Header";
    begin
        //IF WarehouseShipmentLine."Bin Code" = '' then begin
        IF Item.Get(WarehouseReceiptLine."Item No.") then begin
            BinContent.Reset();
            BinContent.SetRange("Item No.", Item."No.");
            BinContent.SetRange("Location Code", WarehouseReceiptLine."Location Code");
            BinContent.SetRange(Default, true);
            if BinContent.FindFirst() then
                WarehouseReceiptLine."Bin Code" := BinContent."Bin Code";
        end;
        //end;
        // SalesHeader.get(SalesLine."Document Type", SalesLine."Document No.");
        // WarehouseReceiptHeader.Validate("Buy-from Type", WarehouseReceiptHeader."Buy-from Type"::Customer);
        // WarehouseReceiptHeader.validate("Buy-from No.", SalesHeader."Sell-to Customer No.");
        // //带出默认制单人
        // WarehouseSetup.get();
        // if WarehouseSetup."Default consignee" <> '' then begin
        //     WarehouseReceiptHeader."Prepared By" := WarehouseSetup."Default consignee";
        // end;
        // WarehouseReceiptHeader.Modify();

    end;

    //==================================================================================================
    //++YK002-HH:销售订单转发货单的时候更新“收货方”信息
    //==================================================================================================
    [EventSubscriber(ObjectType::Report, 5753, 'OnBeforeCreateActivityFromSalesLine2ShptLine', '', false, false)]
    procedure CopyShiptoAdd2(WhseShptHeader: Record "Warehouse Shipment Header"; SalesLine: Record "Sales Line"; var IsHandled: Boolean);
    var
        WarehouseReq: Record "Warehouse Request";
        SalesHeader: Record "Sales Header";
        warehouseSetup: Record "Warehouse Setup";
    begin
        SalesHeader.get(SalesLine."Document Type", SalesLine."Document No.");
        WhseShptHeader.Validate(Remark, SalesHeader.Remark);
        WhseShptHeader.Modify();
    end;

    //==================================================================================================
    //++YK002-HH: 销售退货单创建仓库收货单的时候更新“发货方”字段
    //==================================================================================================
    [EventSubscriber(ObjectType::Report, 5753, 'OnSalesLineOnAfterCreateRcptHeader', '', false, false)]
    procedure CopybuyfromAdd1(var WhseReceiptHeader: Record "Warehouse Receipt Header"; WhseHeaderCreated: Boolean; SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line"; WarehouseRequest: Record "Warehouse Request");
    var
        WarehouseReq: Record "Warehouse Request";
        WarehouseSetup: Record "Warehouse Setup";
    begin
        // SalesHeader.get(SalesLine."Document Type", SalesLine."Document No.");
        // WhseReceiptHeader.Validate("Buy-from Type", WhseReceiptHeader."Buy-from Type"::Customer);
        // WhseReceiptHeader.validate("Buy-from No.", SalesHeader."Sell-to Customer No.");
        // WhseReceiptHeader.Modify();
    end;

    //==================================================================================================
    //++YK002-HH: 采购单创建仓库收货单的时候更新“发货方”字段
    //==================================================================================================
    [EventSubscriber(ObjectType::Report, 5753, 'OnPurchaseLineOnAfterCreateRcptHeader', '', false, false)]
    procedure CopyShiptoAdd4(var WhseReceiptHeader: Record "Warehouse Receipt Header"; WhseHeaderCreated: Boolean; PurchaseHeader: Record "Purchase Header"; PurchaseLine: Record "Purchase Line"; WarehouseRequest: Record "Warehouse Request");
    var
        WarehouseReq: Record "Warehouse Request";
        WarehouseSetup: Record "Warehouse Setup";
    begin
        // PurchaseHeader.get(PurchaseLine."Document Type", PurchaseLine."Document No.");
        // WhseReceiptHeader.Validate("Buy-from Type", WhseReceiptHeader."Buy-from Type"::Vendor);
        // WhseReceiptHeader.Validate("Buy-from No.", PurchaseHeader."Buy-from Vendor No.");
        // WhseReceiptHeader.Modify();
    end;

    //==================================================================================================
    //++YK026：销售订单/采购订单过账时默认为发货/收货（标准功能默认Invoice）
    //==================================================================================================
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post (Yes/No)", 'OnBeforeConfirmPost', '', true, true)]
    procedure OnBeforeConfirmPost(var SalesHeader: Record "Sales Header"; var DefaultOption: Integer; var Result: Boolean; var IsHandled: Boolean)
    var
    begin
        DefaultOption := 1;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", 'OnBeforeConfirmPost', '', true, true)]
    procedure OnBeforeConfirmPost2(var PurchaseHeader: Record "Purchase Header"; var DefaultOption: Integer; var IsHandled: Boolean)
    var
    begin
        DefaultOption := 1;
    end;

    //==================================================================================================
    //++YK026：仓库发货单过账时默认为发货/收货（标准功能默认Invoice）
    //==================================================================================================
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment (Yes/No)", 'OnBeforeConfirmWhseShipmentPost', '', true, true)]
    procedure HideInvoiceOption(var WhseShptLine: Record "Warehouse Shipment Line"; var HideDialog: Boolean; var Invoice: Boolean; var IsPosted: Boolean; var Selection: Integer)
    var
        ShipInvoiceQst: Label '&Ship';
    begin
        HideDialog := true;
        Selection := StrMenu(ShipInvoiceQst, 1);
        Invoice := false;
    end;

    //==================================================================================================
    //++YK001 - FH: 在销售发票上GetShipmentLine的时候将必填字段从销售订单头复制到采购发票头
    //==================================================================================================
    [EventSubscriber(ObjectType::Codeunit, 64, 'OnAfterInsertLines', '', false, false)]
    procedure OnAfterInsertSalesLines(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line")
    var
        SalesShipmentLine: Record "Sales Shipment Line";
        SalesOrderHeader: Record "Sales Header";
    begin
        if SalesShipmentLine.get(SalesLine."Shipment No.", SalesLine."Shipment Line No.") then begin
            if SalesOrderHeader.get(SalesOrderHeader."Document Type"::Order, SalesShipmentLine."Order No.") then begin
                SalesHeader.Validate("External Document No.", SalesOrderHeader."External Document No.");
                SalesHeader.Validate("Order NO.", SalesOrderHeader."No.");
                SalesHeader.Modify();
            end;
        end;
    end;

    //==================================================================================================
    //++YK001 - FH: 在采购发票上GetShipmentLine的时候将必填字段从采购订单头复制到采购发票头
    //==================================================================================================
    [EventSubscriber(ObjectType::Codeunit, 74, 'OnAfterInsertLines', '', false, false)]
    local procedure OnAfterInsertPurcaseLines(var PurchHeader: Record "Purchase Header")
    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
        PurchaseOrderHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
    begin
        PurchLine.Reset();
        PurchLine.SetRange("Document Type", PurchHeader."Document Type");
        PurchLine.SetRange("Document No.", PurchHeader."No.");
        if PurchLine.FindLast() then begin
            if PurchRcptLine.get(PurchLine."Receipt No.", PurchLine."Receipt Line No.") then begin
                if PurchaseOrderHeader.get(PurchaseOrderHeader."Document Type"::Order, PurchRcptLine."Order No.") then begin
                    PurchHeader.Validate("Buy-from Vendor No.", PurchaseOrderHeader."Buy-from Vendor No.");
                    PurchHeader.Validate("Payment Terms Code", PurchaseOrderHeader."Payment Terms Code");
                    //PurchHeader.Validate("Prepared By", PurchaseOrderHeader."Prepared By");
                    PurchHeader."Shortcut Dimension 1 Code" := PurchaseOrderHeader."Shortcut Dimension 1 Code";
                    PurchHeader.Modify();
                end;
            end;
        end;
    end;

    //==================================================================================================
    //++YK001 - FH: 在采购发票上GetShipmentLine的时候将必填字段从采购订单头复制到采购发票头
    //==================================================================================================
    [EventSubscriber(ObjectType::Table, 7316, 'OnBeforeDeleteWhseRcptRelatedLines', '', false, false)]
    local procedure SkipConfirm(var WhseRcptLine: Record "Warehouse Receipt Line"; var SkipConfirm: Boolean)
    begin
        SkipConfirm := true;
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnAfterUpdateSellToCust', '', false, false)]
    local procedure OnAfterUpdateSellToCust(var SalesHeader: Record "Sales Header"; Contact: Record Contact)
    begin
        SalesHeader."Ship-to Name 2" := Contact."Name 2";
    end;


    //==================================================================================================
    //++Harvey - SO 选择Ship-to Code带出Ship-to Address
    //==================================================================================================
    // [EventSubscriber(ObjectType::Table, 36, 'OnBeforeValidateShipToCode', '', false, false)]
    // local procedure OnBeforeValidateShipToCode(var SalesHeader: Record "Sales Header"; xSalesHeader: Record "Sales Header"; Cust: Record Customer; ShipToAddr: Record "Ship-to Address"; var IsHandled: Boolean)
    // begin
    //     IF (SalesHeader."Document Type" <> SalesHeader."Document Type"::"Return Order") AND
    //                (SalesHeader."Document Type" <> SalesHeader."Document Type"::"Credit Memo")
    //             THEN BEGIN
    //         IF SalesHeader."Ship-to Code" <> '' THEN BEGIN
    //             IF xSalesHeader."Ship-to Code" <> '' THEN BEGIN
    //                 SalesHeader.GetCust(SalesHeader."Sell-to Customer No.");
    //                 IF Cust."Location Code" <> '' THEN
    //                     SalesHeader.VALIDATE("Location Code", Cust."Location Code");
    //                 SalesHeader."Tax Area Code" := Cust."Tax Area Code";
    //             END;
    //             ShipToAddr.GET(SalesHeader."Sell-to Customer No.", SalesHeader."Ship-to Code");
    //             SalesHeader."Ship-to Name" := ShipToAddr.Name;
    //             SalesHeader."Ship-to Name 2" := ShipToAddr."Name 2";
    //             SalesHeader."Ship-to Address" := ShipToAddr.Address;
    //             SalesHeader."Ship-to Address 2" := ShipToAddr."Address 2";
    //             SalesHeader."Ship-to City" := ShipToAddr.City;
    //             SalesHeader."Ship-to Post Code" := ShipToAddr."Post Code";
    //             SalesHeader."Ship-to County" := ShipToAddr.County;
    //             SalesHeader.VALIDATE("Ship-to Country/Region Code", ShipToAddr."Country/Region Code");
    //             SalesHeader."Ship-to Contact" := ShipToAddr.Contact;
    //             //STEP001----------
    //             SalesHeader."Ship-to Phone No." := ShipToAddr."Phone No.";
    //             //STEP001++++++++++
    //             SalesHeader."Shipment Method Code" := ShipToAddr."Shipment Method Code";
    //             IF ShipToAddr."Location Code" <> '' THEN
    //                 SalesHeader.VALIDATE("Location Code", ShipToAddr."Location Code");
    //             SalesHeader."Shipping Agent Code" := ShipToAddr."Shipping Agent Code";
    //             SalesHeader."Shipping Agent Service Code" := ShipToAddr."Shipping Agent Service Code";
    //             IF ShipToAddr."Tax Area Code" <> '' THEN
    //                 SalesHeader."Tax Area Code" := ShipToAddr."Tax Area Code";
    //             SalesHeader."Tax Liable" := ShipToAddr."Tax Liable";
    //         END ELSE
    //             IF SalesHeader."Sell-to Customer No." <> '' THEN BEGIN
    //                 SalesHeader.GetCust(SalesHeader."Sell-to Customer No.");
    //                 SalesHeader."Ship-to Name" := Cust.Name;
    //                 SalesHeader."Ship-to Name 2" := Cust."Name 2";
    //                 SalesHeader."Ship-to Address" := Cust.Address;
    //                 SalesHeader."Ship-to Address 2" := Cust."Address 2";
    //                 SalesHeader."Ship-to City" := Cust.City;
    //                 SalesHeader."Ship-to Post Code" := Cust."Post Code";
    //                 SalesHeader."Ship-to County" := Cust.County;
    //                 SalesHeader.VALIDATE("Ship-to Country/Region Code", Cust."Country/Region Code");
    //                 SalesHeader."Ship-to Contact" := Cust.Contact;
    //                 SalesHeader."Shipment Method Code" := Cust."Shipment Method Code";
    //                 SalesHeader."Tax Area Code" := Cust."Tax Area Code";
    //                 SalesHeader."Tax Liable" := Cust."Tax Liable";
    //                 IF Cust."Location Code" <> '' THEN
    //                     SalesHeader.VALIDATE("Location Code", Cust."Location Code");
    //                 SalesHeader."Shipping Agent Code" := Cust."Shipping Agent Code";
    //                 SalesHeader."Shipping Agent Service Code" := Cust."Shipping Agent Service Code";
    //             END;
    //     END;
    // end;

    //==================================================================================================
    //++Harvey - Released PO的时候检查必填字段
    //==================================================================================================
    [EventSubscriber(ObjectType::Codeunit, 415, 'OnBeforeReleasePurchaseDoc', '', false, false)]
    procedure CheckPODimession(var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean)
    var
        PurchLine: Record "Purchase Line";
        DimSetEntry: Record "Dimension Set Entry";
        ErrDim: Label 'Dimension %1 cannot be empty in Purchase Line %2';
        InventorySetup: Record "Inventory Setup";
        Text01: Label 'Direct Unit Cost cannot be zero';
        PurchSetup: Record "Purchases & Payables Setup";
    begin
        //PurchaseHeader.TestField("Purchaser Code");
        If PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order then begin
            PurchaseHeader.TestField("Order Type");
            PurchaseHeader.TestField("Way of Dispatch");
            // PurchaseHeader.TestField("Expected Receipt Date");
        end;

        PurchSetup.Get();
        if not PurchSetup."PO Line Price Mandatory" then exit;
        PurchLine.Reset();
        PurchLine.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchLine.SetRange("Document No.", PurchaseHeader."No.");
        PurchLine.setrange(Type, PurchLine.Type::Item);
        if PurchLine.FindFirst() then
            repeat
                PurchLine.TestField("Direct Unit Cost");
                if PurchLine."Direct Unit Cost" = 0 then begin
                    Error(Text01);
                end;
            until PurchLine.Next() = 0;
    end;


    [EventSubscriber(ObjectType::Codeunit, 99000773, 'OnAfterTransferBOMComponent', '', false, false)]
    local procedure SetProdComponentBin(var ProdOrderLine: Record "Prod. Order Line"; var ProductionBOMLine: Record "Production BOM Line"; var ProdOrderComponent: Record "Prod. Order Component"; LineQtyPerUOM: Decimal; ItemQtyPerUOM: Decimal)
    var
        ProdOrderL: Record "Production Order";
        Item: Record Item;
    begin
        if Item.GET(ProdOrderComponent."Item No.") then begin
            ProdOrderComponent."Trolley No." := Item."Trolley No.";
        end;
    end;

    //----------------------------------------------------------------------------------------
    //++Harvey:检查External Document No.是否存在重复:(1) SQ转SO时 （2）SO提交审批前
    //-----------------------------------------------------------------------------------------
    [EventSubscriber(ObjectType::Codeunit, 1535, 'OnBeforePrePostApprovalCheckSales', '', false, false)]
    local procedure OnBeforePrePostApprovalCheckSales(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    var
        SalesHeader2: Record "Sales Header";
        Text01: Label 'The same External Document No. %1 already exists in order %2 ';
    begin
        SalesHeader.TestField("External Document No.");
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then begin
            SalesHeader2.Reset();
            SalesHeader2.SetRange("Document Type", SalesHeader2."Document Type"::Order);
            SalesHeader2.SETRANGE("External Document No.", DelChr(SalesHeader."External Document No.", '<>', ''));
            if SalesHeader2.FindFirst() then begin
                repeat
                    if (SalesHeader."External Document No." <> '') and (SalesHeader2."No." <> SalesHeader."No.") then begin
                        Message(Text01, SalesHeader."External Document No.", SalesHeader2."No.");
                    end;
                until SalesHeader2.Next() = 0;
            end;
        end;
    end;


    //==================================================================================================
    //++Harvey - SQ转SO 日期都获取当前日期
    //==================================================================================================
    [EventSubscriber(ObjectType::Codeunit, 86, 'OnBeforeModifySalesOrderHeader', '', false, false)]
    local procedure OnBeforeModifySalesOrderHeader(var SalesOrderHeader: Record "Sales Header"; SalesQuoteHeader: Record "Sales Header")
    begin
        SalesOrderHeader."Posting Date" := WorkDate();
        SalesOrderHeader."Order Date" := WorkDate();
        SalesOrderHeader."Document Date" := WorkDate();
        SalesOrderHeader.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, 5763, 'OnCreatePostedShptLineOnBeforePostedWhseShptLineInsert', '', false, false)]
    local procedure ShipLineTOPostedShipLine(var PostedWhseShptLine: Record "Posted Whse. Shipment Line"; WhseShptLine: Record "Warehouse Shipment Line")
    begin
        PostedWhseShptLine."Description 3" := WhseShptLine."Description 3";
        // PostedWhseShptLine.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, 5763, 'OnAfterCreatePostedShptHeader', '', false, false)]
    local procedure CreatePostedShptHeader(var PostedWhseShptHeader: Record "Posted Whse. Shipment Header"; var WarehouseShipmentHeader: Record "Warehouse Shipment Header")
    begin
        PostedWhseShptHeader.Remark := WarehouseShipmentHeader.Remark;
        PostedWhseShptHeader.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, 80, 'OnBeforePostWhseShptLines', '', false, false)]
    local procedure OnBeforePostWhseShptLines(var WhseShptLine2: Record "Warehouse Shipment Line"; SalesShptLine2: Record "Sales Shipment Line"; var SalesLine2: Record "Sales Line"; var IsHandled: Boolean; PostedWhseShptHeader: Record "Posted Whse. Shipment Header")
    begin
        SalesShptLine2."Description 3" := WhseShptLine2."Description 3";
        // SalesShptLine2.Modify();
    end;

    [EventSubscriber(ObjectType::Table, 38, 'OnBeforeOnDelete', '', false, false)]
    local procedure BeforeDelete(var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean)
    begin
        PurchaseHeader.TestField(Status, PurchaseHeader.Status::Open);
    end;

    [EventSubscriber(ObjectType::Page, 7336, 'OnBeforePickCreate', '', false, false)]
    local procedure WarehouseShipmentCreatePick(var WarehouseShipmentLine: Record "Warehouse Shipment Line")
    var
        Lrcd_ShipmentHeader: Record "Warehouse Shipment Header";
        Lrcd_ShipmentLine: Record "Warehouse Shipment Line";
        Lrcd_SalesLine: Record "Sales Line";
        Ltxt_ShowWarning: Text[1000];
    begin
        //STEP001---------
        Ltxt_ShowWarning := '';
        Lrcd_ShipmentLine.RESET;
        Lrcd_ShipmentLine.SETRANGE(Lrcd_ShipmentLine."No.", WarehouseShipmentLine."No.");
        Lrcd_ShipmentLine.SETRANGE("Source Document", Lrcd_ShipmentLine."Source Document"::"Sales Order");
        Lrcd_ShipmentLine.SETFILTER(Lrcd_ShipmentLine."Source No.", '<>%1', '');
        IF Lrcd_ShipmentLine.FIND('-') THEN BEGIN
            Lrcd_SalesLine.RESET;
            Lrcd_SalesLine.SETRANGE(Lrcd_SalesLine."Document Type", Lrcd_SalesLine."Document Type"::Order);
            Lrcd_SalesLine.SETRANGE(Lrcd_SalesLine."Document No.", Lrcd_ShipmentLine."Source No.");
            Lrcd_SalesLine.SETRANGE(Lrcd_SalesLine.Type, Lrcd_SalesLine.Type::" ");
            // Lrcd_SalesLine.SETFILTER(Lrcd_SalesLine.Description,'<>%1','');
            IF Lrcd_SalesLine.FIND('-') THEN
                REPEAT
                    IF STRLEN(Ltxt_ShowWarning) < 950 THEN BEGIN
                        IF Lrcd_SalesLine.Description <> '' THEN
                            Ltxt_ShowWarning += Lrcd_SalesLine.Description + '\';
                        IF Lrcd_SalesLine."Description 2" <> '' THEN
                            Ltxt_ShowWarning += Lrcd_SalesLine."Description 2" + '\';
                    END;
                UNTIL Lrcd_SalesLine.NEXT = 0;
        END;
        IF Ltxt_ShowWarning <> '' THEN
            MESSAGE(FORMAT(Ltxt_ShowWarning));

        //STEP001+++++++++
    end;

    [EventSubscriber(ObjectType::Codeunit, 7313, 'OnBeforeWhseActivLineInsert', '', false, false)]
    local procedure WhseActivLineInsert(var WarehouseActivityLine: Record "Warehouse Activity Line"; PostedWhseRcptLine: Record "Posted Whse. Receipt Line")
    var
        Item: Record Item;
    begin
        if Item.get(PostedWhseRcptLine."Item No.") then begin
            WarehouseActivityLine."Trolley No." := Item."Trolley No.";
        end;
    end;

    // [EventSubscriber(ObjectType::Codeunit, 7312, 'OnBeforeWhseActivHeaderInsert', '', false, false)]
    // local procedure WhseActivHeaderInsert(var WarehouseActivityHeader: Record "Warehouse Activity Header"; var TempWhseActivityLine: Record "Warehouse Activity Line" temporary; CreatePickParameters: Record "Create Pick Parameters"; WhseShptLine: Record "Warehouse Shipment Line")
    // var
    //     Item: Record Item;
    // begin
    //     if Item.get(WhseShptLine."Item No.") then begin
    //         TempWhseActivityLine."Trolley No." := Item."Trolley No.";
    //         TempWhseActivityLine.Modify();
    //     end;
    // end;

    //==================================================================================================
    //++Harvey - 修改销售头location code 同步修改行里location code
    //==================================================================================================
    [EventSubscriber(ObjectType::Table, 36, 'OnBeforeMessageIfSalesLinesExist', '', false, false)]
    local procedure ValidateSalesLocationCode(SalesHeader: Record "Sales Header"; ChangedFieldCaption: Text; var IsHandled: Boolean)
    var
        SalesLine: Record "Sales Line";
        Text001: Label 'Will you modify location code in lines?';
    begin
        //++ALF
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice then
            exit;
        //--ALF
        if Confirm(Text001, true) then begin
            IsHandled := true;
            SalesLine.Reset();
            SalesLine.SetRange("Document Type", SalesHeader."Document Type");
            SalesLine.SetRange("Document No.", SalesHeader."No.");
            SalesLine.SetRange(Type, SalesLine.Type::Item);
            if SalesLine.FindFirst() then
                repeat
                    SalesLine."Location Code" := SalesHeader."Location Code";
                    SalesLine.Modify();
                until SalesLine.Next() = 0;
        end;
    end;

    //==================================================================================================
    //++Harvey - 修改采购头location code 同步修改行里location code
    //==================================================================================================
    [EventSubscriber(ObjectType::Table, 38, 'OnBeforeValidateLocationCode', '', false, false)]
    local procedure ValidatePurchaseLocationCode(var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean)
    var
        PurchaseLine: Record "Purchase Line";
        Text001: Label 'Will you modify location code in lines?';
    begin

        IsHandled := true;
        //++ALF
        if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice then
            exit;
        //--ALF
        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        if PurchaseLine.FindFirst() then begin
            if not Confirm(Text001, true) then
                exit;
            repeat
                if PurchaseLine."Location Code" <> PurchaseHeader."Location Code" then begin
                    PurchaseLine."Location Code" := PurchaseHeader."Location Code";
                    PurchaseLine.Modify();
                end;
            until PurchaseLine.Next() = 0;
        end;
    end;

    //==================================================================================================
    //++Harvey - 销售发票过账 把Order No.带到已过账的销售发票
    //==================================================================================================
    [EventSubscriber(ObjectType::Codeunit, 80, 'OnAfterInsertInvoiceHeader', '', false, false)]
    local procedure SalesHeadertoSalesInvoiceHeader(var SalesHeader: Record "Sales Header"; var SalesInvHeader: Record "Sales Invoice Header")
    begin
        SalesInvHeader."Order No." := SalesHeader."Order No.";
        SalesInvHeader.Modify();
    end;

    //==================================================================================================
    //++Harvey - 打印SO SQ 修改单价为折扣后单价
    //==================================================================================================
    [EventSubscriber(ObjectType::Codeunit, 368, 'OnAfterSetSalesLine', '', false, false)]
    local procedure OnAfterSetSalesLine(var SalesLine: Record "Sales Line"; var FormattedQuantity: Text; var FormattedUnitPrice: Text; var FormattedVATPercentage: Text; var FormattedLineAmount: Text);
    var
        Unitprice: Decimal;
    begin
        if FormattedUnitPrice <> '' then
            Evaluate(Unitprice, FormattedUnitPrice)
        else
            Unitprice := 0;
        FormattedUnitPrice := Format((100 - SalesLine."Line Discount %") * 0.01 * Unitprice);
    end;

    //==================================================================================================
    //++Harvey - 打印PO 并且在POLine 上添加Extended Text
    //==================================================================================================
    [EventSubscriber(ObjectType::Codeunit, 378, 'OnBeforeInsertPurchExtText', '', false, false)]
    local procedure BeforeInsertPurchExtText(var PurchLine: Record "Purchase Line"; var TempExtTextLine: Record "Extended Text Line" temporary; var IsHandled: Boolean; var MakeUpdateRequired: Boolean)
    begin
        TempExtTextLine.Text := TempExtTextLine.Text + '/' + TempExtTextLine.Sheet + '/' + TempExtTextLine.Index;
        TempExtTextLine.Modify();
    end;

    //==================================================================================================
    //++Harvey - PO Send Approval 检查必填项
    //==================================================================================================
    [EventSubscriber(ObjectType::Codeunit, 1535, 'OnBeforeCheckPurchaseApprovalPossible', '', false, false)]
    local procedure BeforeCheckPurchaseApprovalPossible(PurchaseHeader: Record "Purchase Header"; var Result: Boolean; var IsHandled: Boolean)
    begin
        PurchaseHeader.TestField("Purchaser Code");
        PurchaseHeader.TestField("Way of Dispatch");
    end;


    //==================================================================================================
    //++Harvey - PI get purchase receipt line 修改PI头上Posting Description
    //==================================================================================================
    [EventSubscriber(ObjectType::Codeunit, 74, 'OnAfterInsertLines', '', false, false)]
    local procedure OnAfterInsertLines(var PurchHeader: Record "Purchase Header")
    var
        PurchLine: Record "Purchase Line";
    begin
        PurchLine.Reset();
        PurchLine.SetRange("Document Type", PurchLine."Document Type"::Invoice);
        PurchLine.SetRange("Document No.", PurchHeader."No.");
        if PurchLine.FindLast() then begin
            PurchLine.CalcFields("PO No.");
            PurchHeader."Posting Description" := PurchLine."PO No.";
            PurchHeader.Modify();
        end;
    end;

    //==================================================================================================
    //++Harvey - 销售发票过账 把Order No.带到Cust. ledger entry
    //==================================================================================================
    // [EventSubscriber(ObjectType::Codeunit, 80, 'OnAfterUpdateSalesHeader', '', false, false)]
    // local procedure OnBeforeUpdateSalesHeader(var CustLedgerEntry: Record "Cust. Ledger Entry"; var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; GenJnlLineDocType: Integer)
    // var
    //     TmpSalesOrder: Record "Sales Header" temporary;
    //     SalesInvLine: Record "Sales Invoice Line";
    //     OrderNo: Text[100];
    // begin
    //     OrderNo := '';
    //     SalesInvLine.Reset();
    //     SalesInvLine.SetRange("Document No.", SalesInvoiceHeader."No.");
    //     if SalesInvLine.FindFirst() then
    //         repeat
    //             TmpSalesOrder.Init();
    //             TmpSalesOrder."Document Type" := TmpSalesOrder."Document Type"::Order;
    //             TmpSalesOrder."No." := SalesInvLine."Order No.";
    //             if TmpSalesOrder.Insert() then;
    //         until SalesInvLine.Next() = 0;

    //     TmpSalesOrder.Reset();
    //     if TmpSalesOrder.FindFirst() then
    //         repeat
    //             OrderNo := OrderNo + TmpSalesOrder."No." + ';';
    //         until TmpSalesOrder.Next() = 0;
    //     CustLedgerEntry."Order No." := OrderNo;
    //     //CustLedgerEntry.Modify();
    // end;
}
