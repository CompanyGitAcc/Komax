page 50101 "Posted Documents"
{
    Caption = 'Posted Documents';
    PageType = List;
    SourceTable = "Posted Documents";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = all;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Cost Amount(Expected)"; Rec."Cost Amount(Expected)")
                {
                    ApplicationArea = All;
                }
                field("Cost Amount(Actual)"; Rec."Cost Amount(Actual)")
                {
                    ApplicationArea = All;
                }
                field("GL-Inventory"; Rec."GL-Inventory")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Function")
            {
                Caption = 'Function';
                Image = Process;
                action("Referesh")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Referesh';
                    Image = View;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ValueEntry: Record "Value Entry";
                        GLEntry: Record "G/L Entry";
                        InvDiff: Record "Posted Documents";
                        window: Dialog;
                    begin
                        window.open('#1######');
                        InvDiff.Reset();
                        if InvDiff.FindFirst() then
                            InvDiff.DeleteAll();
                        ValueEntry.Reset();
                        if ValueEntry.FindFirst() then
                            repeat
                                window.Update(1, ValueEntry."Entry No.");
                                InvDiff.Init();
                                InvDiff."Document Type" := ValueEntry."Document Type";
                                InvDiff."Document No." := ValueEntry."Document No.";
                                InvDiff."Inventory Account Filter" := GLSetup."Inventory Account Filter";
                                If InvDiff.Insert() then
                                    InvDiff.Modify();
                            until ValueEntry.Next() = 0;
                        GLEntry.Reset();
                        GLEntry.Setfilter("G/L Account No.", GLSetup."Inventory Account Filter");
                        if GLEntry.FindFirst() then
                            repeat
                                window.Update(1, GLEntry."Entry No.");
                                InvDiff.Init();
                                InvDiff."Document Type" := InvDiff."Document Type"::" ";
                                InvDiff."Document No." := GLEntry."Document No.";
                                If InvDiff.Insert() then;
                            until GLEntry.Next() = 0;

                        window.Close();
                        ;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        GLSetup.Get();
        GLSetup.TestField("Inventory Account Filter");
        Rec.SetFilter("Inventory Account Filter", GLSetup."Inventory Account Filter");
        Rec.SetRange("Date Filter", WorkDate());
    end;

    trigger OnAfterGetRecord()
    begin

    end;

    var
        GLSetup: Record "General Ledger Setup";
}
