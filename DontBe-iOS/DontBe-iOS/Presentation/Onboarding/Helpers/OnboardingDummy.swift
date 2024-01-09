//
//  OnboardingDummy.swift
//  DontBe-iOS
//
//  Created by 변희주 on 1/9/24.
//

import UIKit

struct OnboardingDummy {
    let progress: UIImage
    let titleImage: UIImage
    let mainImage: UIImage
}

extension OnboardingDummy {
    static func dummy() -> [OnboardingDummy] {
        return [OnboardingDummy(progress: ImageLiterals.Onboarding.progressbar1,
                                titleImage: ImageLiterals.Onboarding.imgOneTitle,
                                mainImage: ImageLiterals.Onboarding.imgOne),
                OnboardingDummy(progress: ImageLiterals.Onboarding.progressbar2,
                                titleImage: ImageLiterals.Onboarding.imgTwoTitle,
                                mainImage: ImageLiterals.Onboarding.imgTwo),
                OnboardingDummy(progress: ImageLiterals.Onboarding.progressbar3,
                                titleImage: ImageLiterals.Onboarding.imgThirdTitle,
                                mainImage: ImageLiterals.Onboarding.imgThird)]
    }
}
