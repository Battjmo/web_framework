require_relative '../templates'

class Templates
    describe Template do 
        it "renders templates" do
            source = <<~END
                div
                    p
                        | User:
                    p
                        = 1 + 1
                END

                expected = <<~END
                <div>
                    <p>
                        User:
                    </p>
                    <p>
                        nick@example.com
                    </p>
                </div>
                END
                rendered = Template.new(source).render(email: 'nick@example.com')
                expect(rendered).to eq expected
        end 
    end 
end 

