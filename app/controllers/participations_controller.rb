class ParticipationsController < ApplicationController


  def index
    policy_scope(Participation)
    @participations = Participation.all.order("created_at DESC")
    @events = Event.all
  end

  def show

    @participation = Participation.find(params[:id])
    authorize @participation
    @event_id = @participation.event_id
    @event=Event.where(id:@event_id).first
    @places_dispo = @event.number_of_participants - @event.participations.where(status:'payé').sum(:quantity)
  end


  def new
    @participation = Participation.new
    @participation.user = current_user
    @event = Event.find(params[:event_id])
  end


  def create
    @event = Event.find(params[:event_id])
    @participation = Participation.new(participation_params)

    @participation.user = current_user
    @participation.first_name = current_user.first_name
    @participation.last_name = current_user.first_name
    @participation.email = current_user.email
    @participation.event_ref = @event.name
    @participation.event_id = @event.id
    @participation.amount_cents = @event.price_cents * @participation.quantity
    authorize @participation
      @places_dispo = @event.number_of_participants - @event.participations.where(status:'payé').sum(:quantity) - @participation.quantity
       if @places_dispo > 0
         @participation.save
          redirect_to new_participation_charge_path(@participation)
       else
          render action: 'show'
          puts 'pas assez de places disponibles'
       end

  end





  private

    def participation_params
      params.require(:participation).permit(:first_name, :last_name, :email, :phone, :status, :quantity, :event_ref, :amount_cents, :user, :available_places, :event_id)
    end

end
