pageextension 59035 "TP Posted Sales Invoices" extends "Posted Sales Invoices"
{
    layout
    {
        addafter("No.")
        {
            field("Order Type"; Rec."Order Type")
            {
                ApplicationArea = all;
            }
        }
        modify("External Document No.")
        {
            Visible = true;
        }
        moveafter("Order Type"; "External Document No.")
    }
    trigger OnOpenPage()
    begin
        UpdateOrderType(false);
    end;

    procedure UpdateOrderType(UpdateAll: Boolean)
    var
        window: Dialog;
        SalesInvHeader: Record "Sales Invoice Header";
        SalesInvLine: Record "Sales Invoice Line";
        TmpItem: Record Item temporary;
        Nos: Text;
    begin
        window.Open('Update Order #1#########');
        SalesInvHeader.Reset();
        If not UpdateAll then
            SalesInvHeader.setrange("Order Type", 0);
        if SalesInvHeader.FindFirst() then
            repeat
                Nos := '';
                TmpItem.Reset();
                if TmpItem.FindFirst() then
                    TmpItem.DeleteAll();
                window.Update(1, SalesInvHeader."No.");
                SalesInvLine.Reset();
                SalesInvLine.SetRange("Document No.", SalesInvHeader."No.");
                SalesInvLine.SetRange(Type, SalesInvLine.Type::Item);
                if SalesInvLine.FindFirst() then
                    repeat
                        TmpItem.Init();
                        TmpItem."No." := SalesInvLine."Order No.";
                        if TmpItem.Insert() then;
                    until SalesInvLine.Next() = 0;
                TmpItem.Reset();
                if TmpItem.FindFirst() then begin
                    if SalesHeader.get(SalesHeader."Document Type"::Order, TmpItem."No.") then begin
                        SalesInvHeader."Order Type" := SalesHeader."Order Type";
                        SalesInvHeader."External Document No." := SalesHeader."External Document No.";
                        SalesInvHeader.Modify();
                    end;
                end;

            until SalesInvHeader.Next() = 0;
        window.Close();
    end;

    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
}
