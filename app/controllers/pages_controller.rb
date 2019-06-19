class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :cgu, :confidentialite]

  def home
  end

  def cgu
  end

  def confidentialite
  end
end
