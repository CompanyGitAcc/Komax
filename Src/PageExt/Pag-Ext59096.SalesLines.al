pageextension 59096 "TP Sales Lines" extends "Sales Lines"
{
    layout
    {
        addafter("Sell-to Customer No.")
        {
            field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
            {
                ApplicationArea = all;
            }
            field(Department; Department)
            {
                Caption = 'Department';
                ApplicationArea = all;
            }
        }
    }
    //------------------------------------------------------------
    //#VOL1.00 - ALF - 2021/11/25
    //增加方法：SelectSalesLines，该方法用在采购单页面上，可以从销售单抓数据到采购单
    //------------------------------------------------------------       
    procedure SelectSalesLines(OrderNo: Code[20]): Text
    var
        SalesLine: Record "Sales Line";
        SalesLinePage: Page "Sales Lines";
    begin
        //#1
        SalesLine.SETRANGE("Document Type", SalesLine."Document Type"::Order);
        IF OrderNo <> '' THEN
            SalesLine.SETRANGE("Document No.", OrderNo);
        SalesLine.SETRANGE(Type, SalesLine.Type::Item);

        //EXIT(SelectInSalesLines(SalesLine));
        SalesLinePage.SETTABLEVIEW(SalesLine);
        SalesLinePage.LOOKUPMODE(TRUE);
        IF SalesLinePage.RUNMODAL = ACTION::LookupOK THEN
            EXIT(SalesLinePage.GetSelectionFilter);
    end;

    procedure GetSelectionFilter(): Text
    Var
        SalesLine: Record "Sales Line";
        VoltageUtil: Codeunit "TP Utilities";
    begin
        CurrPage.SETSELECTIONFILTER(SalesLine);
        EXIT(VoltageUtil.GetSelectionFilterForSalesLine(SalesLine)); //#BC190
    end;

    trigger OnAfterGetRecord()
    begin
        if DimensionValue.get('Department', Rec."Shortcut Dimension 1 Code") then begin
            Department := DimensionValue.Name;
        end else
            Department := '';
    end;


    var
        Department: Text[100];
        DimensionValue: Record "Dimension Value";

}


