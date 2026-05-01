import Link from 'next/link'
import { Bird, Bug, Cat, ChefHat, Fish } from 'lucide-react'
import { PassionLevelEditor } from '@/components/PassionLevelEditor'

export default function HomePage() {
  return (
    <main className="container flex min-h-screen flex-col items-center justify-center py-16">
      <section className="flex flex-col items-center text-center">
        <span className="mb-4 inline-flex items-center rounded-full bg-primary/10 px-3 py-1 text-xs font-medium text-primary">
          v0.1 — En construction
        </span>
        <h1 className="text-4xl font-bold tracking-tight sm:text-6xl">
          Heartopia <span className="text-primary">Companion</span>
        </h1>
        <p className="mt-6 max-w-2xl text-lg text-muted-foreground">
          Votre assistant interactif pour Heartopia. Suivez vos poissons, insectes et oiseaux,
          et optimisez vos recettes de cuisine pour maximiser vos profits.
        </p>
      </section>

      <section className="mt-16 grid w-full max-w-5xl gap-4 sm:grid-cols-2 lg:grid-cols-5">
        <FeatureCard
          href="/tracker/fish"
          icon={<Fish className="h-6 w-6" />}
          title="Poissons"
          description="Filtrez par horaire, météo et ombre."
        />
        <FeatureCard
          href="/tracker/insects"
          icon={<Bug className="h-6 w-6" />}
          title="Insectes"
          description="Localisations et conditions précises."
        />
        <FeatureCard
          href="/tracker/birds"
          icon={<Bird className="h-6 w-6" />}
          title="Oiseaux"
          description="Distance idéale pour la photo parfaite."
        />
        <FeatureCard
          href="/cuisine"
          icon={<ChefHat className="h-6 w-6" />}
          title="Cuisine"
          description="Optimiseur de profits en temps réel."
        />
        <FeatureCard
          href="/chat"
          icon={<Cat className="h-6 w-6" />}
          title="Chat 🐱"
          description="Trouvez les plats préférés de votre chat."
        />
      </section>

      <div className="mt-12 w-full max-w-5xl">
        <PassionLevelEditor />
      </div>

      <footer className="mt-16 text-center text-sm text-muted-foreground">
        <p>Heartopia Companion — v0.1</p>
      </footer>
    </main>
  )
}

function FeatureCard({
  href,
  icon,
  title,
  description,
}: {
  href: string
  icon: React.ReactNode
  title: string
  description: string
}) {
  return (
    <Link
      href={href}
      className="flex flex-col items-start gap-2 rounded-xl border border-border bg-card p-5 transition-colors hover:border-primary/40 hover:shadow-md"
    >
      <div className="text-primary">{icon}</div>
      <h3 className="font-semibold">{title}</h3>
      <p className="text-sm text-muted-foreground">{description}</p>
    </Link>
  )
}
