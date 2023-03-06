page 50076 "Production Shortage"
{
    PageType = List;
    SourceTable = "Production Order";

    layout
    {
        area(content)
        {
            group(Group1)
            {
                field(CalcOption; CalcOption)
                {
                    Caption = 'Calculate Option';
                    OptionCaption = 'WIP/PRODINBOUND,Production Inventory,Production + Purchase';

                    trigger OnValidate()
                    begin
                        TransOption
                    end;
                }
                field(Gbol_WIP; Gbol_WIP)
                {
                    Caption = 'WIP';
                    Enabled = false;
                    Visible = false;
                }
                field(Gbol_RAW; Gbol_RAW)
                {
                    Caption = 'RAW MATERIAL`';
                    Enabled = false;
                    Visible = false;

                    trigger OnValidate()
                    begin
                        IF Gbol_RAW = TRUE THEN
                            Gbol_AutoC := FALSE;
                    end;
                }
                field(Gbol_Purchase; Gbol_Purchase)
                {
                    Caption = 'Purchase Order';
                    Enabled = false;
                    Visible = false;
                }
            }
            group(Group2)
            {
                field(Gbol_AutoC; Gbol_AutoC)
                {
                    Caption = 'Auto Create C-Parts Movement';

                    trigger OnValidate()
                    begin
                        IF Gbol_AutoC = TRUE THEN BEGIN
                            IF Gbol_RAW = TRUE THEN
                                Gbol_AutoC := FALSE
                            ELSE BEGIN
                                IF NOT CONFIRM(TEXT0003) THEN
                                    Gbol_AutoC := FALSE;
                            END;
                        END;
                    end;
                }
            }
            repeater(Group)
            {
                field(Status; Rec.Status)
                {
                }
                field("No."; Rec."No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Source Type"; Rec."Source Type")
                {
                }
                field("Source No."; Rec."Source No.")
                {
                }
                field("Due Date"; Rec."Due Date")
                {
                }
                field("Finished Date"; Rec."Finished Date")
                {
                }
                field("Location Code"; Rec."Location Code")
                {
                }
                field("Seclect Run Report"; Rec."Seclect Run Report")
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Select All")
            {
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.SETFILTER(Status, '%1|%2|%3', Rec.Status::Planned, Rec.Status::"Firm Planned", Rec.Status::Released);
                    Rec.MODIFYALL("Seclect Run Report", TRUE);
                end;
            }
            action("UnSelect All")
            {
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.SETFILTER(Status, '%1|%2|%3', Rec.Status::Planned, Rec.Status::"Firm Planned", Rec.Status::Released);
                    Rec.MODIFYALL("Seclect Run Report", FALSE);
                end;
            }
            action("Run Report")
            {
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Gtxt_ProdNo := '';
                    Gint_No := 0;
                    Gint_Count := 0;

                    Grcd_ProdOrder.RESET;
                    Grcd_ProdOrder := Rec;
                    Grcd_ProdOrder.SETFILTER(Status, '%1|%2|%3', Rec.Status::Planned, Rec.Status::"Firm Planned", Rec.Status::Released);
                    Grcd_ProdOrder.SETRANGE("Seclect Run Report", TRUE);
                    IF Grcd_ProdOrder.FIND('-') THEN
                        Gint_No := Grcd_ProdOrder.COUNT;
                    IF Gint_No = 0 THEN BEGIN
                        ERROR(TEXT0001);
                    END
                    ELSE BEGIN
                        REPEAT
                            Gint_Count += 1;
                            IF Gint_Count = Gint_No THEN BEGIN
                                Gtxt_ProdNo += FORMAT(Grcd_ProdOrder."No.");
                            END
                            ELSE BEGIN
                                Gtxt_ProdNo += FORMAT(Grcd_ProdOrder."No.") + '|';
                            END;
                        UNTIL Grcd_ProdOrder.NEXT = 0;
                    END;
                    IF (NOT Gbol_WIP) AND (NOT Gbol_RAW) THEN
                        ERROR('You must select WIP or RAW MATERIAL to consume!');
                    CLEAR(Grpt_BinShortage);
                    Grpt_BinShortage.TransferProdOrder(Gtxt_ProdNo);
                    Grpt_BinShortage.TransferBinPurchseFalg(Gbol_WIP, Gbol_RAW, Gbol_Purchase, Gbol_AutoC);
                    Grpt_BinShortage.RUN;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.RESET;
        Rec.MODIFYALL("Seclect Run Report", FALSE);
        Rec.SETFILTER(Status, '%1|%2|%3', Rec.Status::Planned, Rec.Status::"Firm Planned", Rec.Status::Released);
        Rec.SETFILTER("No.", '<>%1', '');
        Rec.SETFILTER("Source No.", '<>%1', '');

        TransOption
    end;

    var
        Grcd_ProdOrder: Record "Production Order";
        Grpt_BinShortage: Report "Shortage Report New";
        Gtxt_ProdNo: Text[1000];
        Gint_No: Integer;
        Gint_Count: Integer;
        TEXT0001: Label 'You select no Production Order. No report will run!';
        Gbol_WIP: Boolean;
        Gbol_RAW: Boolean;
        Gbol_Purchase: Boolean;
        Gbol_AutoC: Boolean;
        TEXT0003: Label 'After you have runned the report ,It will auto create C-Parts shortage from RAW Material to WIP!';
        CalcOption: Option WIP,Production,Prod_Purch;

    procedure TransOption()
    begin
        CASE CalcOption OF
            CalcOption::WIP:
                BEGIN
                    Gbol_WIP := TRUE;
                    Gbol_RAW := FALSE;
                    Gbol_Purchase := FALSE;
                END;
            CalcOption::Production:
                BEGIN
                    Gbol_WIP := TRUE;
                    Gbol_RAW := TRUE;
                    Gbol_Purchase := FALSE;
                END;
            CalcOption::Prod_Purch:
                BEGIN
                    Gbol_WIP := TRUE;
                    Gbol_RAW := TRUE;
                    Gbol_Purchase := TRUE;
                END;

        END;
    end;
}

