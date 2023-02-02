pageextension 59176 "TP Config. Package Card" extends "Config. Package Card"
{
    layout
    {
        addafter("Processing Order")
        {
            field("Assigned User ID"; Rec."Assigned User ID")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        modify(ImportFromExcel)
        {
            trigger OnBeforeAction()
            var
                UserSetup: Record "User Setup";
            begin
                Rec.TestField("Assigned User ID");
                If (rec."Assigned User ID" <> UserId) then
                    Error('You are not autherized to process this.');
                ;

            end;
        }
        modify(ExportToExcel)
        {
            trigger OnBeforeAction()
            var
                UserSetup: Record "User Setup";
            begin
                Rec.TestField("Assigned User ID");
                If (rec."Assigned User ID" <> UserId) then
                    Error('You are not autherized to process this.');
                ;

            end;
        }
    }
}
