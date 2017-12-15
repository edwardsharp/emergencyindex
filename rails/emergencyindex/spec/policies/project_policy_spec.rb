require 'rails_helper'

describe ProjectPolicy do
  subject { ProjectPolicy.new(user, project) }

  let(:project) { FactoryBot.create(:project) }

  context "for a visitor" do
    let(:user) { nil }

    it { should     permit(:index)   }
    it { should     permit(:show)    }

    it { should_not permit(:create)  }
    it { should_not permit(:new)     }
    it { should_not permit(:update)  }
    it { should_not permit(:edit)    }
    it { should_not permit(:destroy) }
  end

  context "for a user's own project" do
    let(:user) { FactoryBot.create(:user){ |user| project.user = user } }
    # let(:project) { project.user = user }

    it { should permit(:index)   }
    it { should permit(:show)    }
    it { should permit(:create)  }
    it { should permit(:new)     }
    it { should permit(:update)  }
    it { should permit(:edit)    }
    it { should permit(:destroy) }
  end

  context "for an admin" do
    let(:user) { FactoryBot.create(:admin) }

    it { should permit(:index)   }
    it { should permit(:show)    }
    it { should permit(:create)  }
    it { should permit(:new)     }
    it { should permit(:update)  }
    it { should permit(:edit)    }
    it { should permit(:destroy) }

  end

end
