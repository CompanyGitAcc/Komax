pageextension 59170 "TP Warehouse Put-away" extends "Warehouse Put-away"
{
    layout
    {
        addlast(General)
        {
            field("Put-away Bin Code"; Rec."Put-away Bin Code")
            {
                ApplicationArea = all;
            }
        }

    }

    actions
    {
        addafter("&Print")
        {
            action("Print Put-away")
            {
                Caption = 'Print Put-away';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    PutAwayList: Report "Put Away List";
                    WarehouseActivityHeader: Record "Warehouse Activity Header";
                begin
                    WarehouseActivityHeader.SetRange(Type, Rec.Type::"Put-away");
                    WarehouseActivityHeader.SetRange("No.", Rec."No.");
                    PutAwayList.SetTableView(WarehouseActivityHeader);
                    PutAwayList.RunModal();
                end;
            }
        }
    }



}
