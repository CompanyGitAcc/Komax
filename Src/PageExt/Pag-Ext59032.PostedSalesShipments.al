pageextension 59032 "TP Posted Sales Shipments" extends "Posted Sales Shipments"
{
    layout
    {


        addafter("No.")
        {
            field("Source Code"; Rec."Source Code")
            {
                ApplicationArea = all;
            }

            field(Remark; Rec.Remark)
            {
                ApplicationArea = all;
            }

        }
        addafter("Location Code")
        {
            field("Assigned User ID"; Rec."Assigned User ID")
            {
                ApplicationArea = all;
            }
        }
        modify("Salesperson Code")
        {
            Visible = true;
        }
        modify("External Document No.")
        {
            Visible = true;
        }
        modify("Posting Date")
        {
            Visible = true;
        }

        movefirst(Control1; "No.", "Sell-to Customer No.", "Sell-to Customer Name", "Salesperson Code", "External Document No.", "Currency Code", "Location Code", "No. Printed", "Posting Date")
        addafter("Sell-to Customer Name")
        {
            field("Bill-to Name 2"; Rec."Bill-to Name 2")
            {
                ApplicationArea = all;
            }
        }
        addafter("External Document No.")
        {
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = all;
            }
        }
        addafter("No. Printed")
        {
            field("Order Type"; Rec."Order Type")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        addafter("&Print")
        {
            action("Print Posted Sales Shipment")
            {
                Caption = 'Print Posted Sales Shipment';
                Image = Print;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                var
                    SalesShipment: Report "Sales Shipment";
                    SalesShipmentHeader: Record "Sales Shipment Header";
                    SalesShipmentHeader2: Record "Sales Shipment Header";
                    DocFilter: Text;
                begin
                    // Currpage.setselectionfilter(SalesShipmentHeader);
                    // SalesShipmentHeader.SetRange("No.", Rec."No.");
                    // SalesShipment.Settableview(SalesShipmentHeader);
                    // SalesShipment.Runmodal();

                    SalesShipmentHeader.Reset();
                    CurrPage.SetSelectionFilter(SalesShipmentHeader);
                    if SalesShipmentHeader.FindFirst() then
                        repeat
                            if DocFilter = '' then
                                DocFilter := SalesShipmentHeader."No."
                            else
                                DocFilter := DocFilter + '|' + SalesShipmentHeader."No.";
                        until SalesShipmentHeader.Next() = 0;
                    SalesShipmentHeader2.Reset();
                    SalesShipmentHeader2.SetFilter("No.", DocFilter);
                    SalesShipment.SetTableView(SalesShipmentHeader2);
                    SalesShipment.RunModal();
                end;
            }
            action("Copy Remarks")
            {
                Caption = 'Copy Order Remarks';
                Image = Print;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                var
                    SalesShipmentHeader: Record "Sales Shipment Header";
                    SalesHeader: Record "Sales Header";
                    SalesShipmentLine: Record "Sales Shipment Line";
                    SalesLine: Record "Sales Line";
                    window: Dialog;
                begin
                    Window.Open('#1###########');
                    SalesShipmentHeader.Reset();
                    if SalesShipmentHeader.FindFirst() then
                        repeat
                            window.update(1, SalesShipmentHeader."No.");
                            if SalesHeader.get(SalesHeader."Document Type"::Order, SalesShipmentHeader."Order No.") then begin
                                SalesShipmentHeader."Order Type" := SalesHeader."Order Type";
                                SalesShipmentHeader.Remark := SalesHeader.Remark;
                                SalesShipmentHeader.Modify();
                            end;
                        until SalesShipmentHeader.Next() = 0;

                    SalesShipmentLine.Reset();
                    if SalesShipmentLine.FindFirst() then
                        repeat
                            window.update(1, SalesShipmentLine."document No.");
                            if SalesLine.get(SalesLine."Document Type"::Order, SalesShipmentLine."Order No.", SalesShipmentLine."Order Line No.") then begin
                                SalesShipmentLine.Remark := SalesLine.Remark;
                                SalesShipmentLine.Modify();
                            end;
                        until SalesShipmentLine.Next() = 0;
                    window.Close();
                end;
            }
        }
        addafter("Update Document")
        {
            //导出顺丰面单
            action("Export SF Sheet")
            {
                Caption = 'Export SF Sheet';
                Image = Excel;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    PostedSalesShipment: Record "Sales Shipment Header";
                begin
                    CurrPage.SetSelectionFilter(PostedSalesShipment);
                    ExportSFSheet(PostedSalesShipment);
                end;
            }
        }
    }
    procedure ExportSFSheet(var SalesShptHeader: Record "Sales Shipment Header")
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        CustLedgerEntriesLbl: Label '导入模板';
        ExcelFileName: Label 'SF_%1_%2';
        CompanyInfo: Record "Company Information";
    begin
        CompanyInfo.get();
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('用户订单号', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('寄件公司', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('寄件人', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('寄件电话', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('寄件详细地址', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('收件公司', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('收件人', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('收件电话', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('收件手机', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('收件详细地址', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('托寄物内容', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('托寄物数量', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('包裹重量', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('寄方备注', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('运费付款方式', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('业务类型', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);

        if SalesShptHeader.FindSet() then
            repeat
                TempExcelBuffer.NewRow();
                TempExcelBuffer.AddColumn(SalesShptHeader."External Document No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CompanyInfo."Name 2", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
                TempExcelBuffer.AddColumn(CompanyInfo."Contact Person", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CompanyInfo."Phone No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(CompanyInfo."Address 2", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesShptHeader."Ship-to Name 2", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesShptHeader."Ship-to Contact", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesShptHeader."Ship-to Phone No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesShptHeader."Ship-to Phone No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesShptHeader."Ship-to Address 2", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn('', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(SalesShptHeader."Order No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn('寄付月结', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn('顺丰标快', false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            until SalesShptHeader.Next() = 0;
        TempExcelBuffer.CreateNewBook(CustLedgerEntriesLbl);
        TempExcelBuffer.WriteSheet(CustLedgerEntriesLbl, CompanyName, UserId);
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename(StrSubstNo(ExcelFileName, CurrentDateTime, UserId));
        TempExcelBuffer.OpenExcel();
    end;

}
