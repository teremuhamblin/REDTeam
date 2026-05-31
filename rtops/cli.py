import click
from rtops import __version__
from rtops.recon import passive_recon
from rtops.utils.config_loader import load_config

@click.group()
@click.version_option(__version__)
@click.option("--config", "-c", default=None, help="Path to config file")
@click.pass_context
def main(ctx, config):
    """rtops CLI - REDTeam toolkit (lab only)."""
    ctx.obj = {}
    ctx.obj["config"] = load_config(config)

@main.command()
@click.argument("target", required=False)
def recon(target):
    """Run passive reconnaissance (lab only)."""
    click.echo("Lancement reconnaissance passive...")
    results = passive_recon.run(target or "example.com")
    click.echo(f"Résultats: {results}")

if __name__ == "__main__":
    main()
